
class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  field  :key ,              type: String # unique key identifying project (subfolder under /projects holding project jsons)
  field  :author,            type: String, default: "NYPL/Zooniverse"
  field  :title,             type: String, default: "Project X: A Scribe Project"
  field  :short_title,       type: String, default: "Project X"
  field  :team,              type: Array,  default: []
  field  :summary ,          type: String, default: "Scribe is a crowdsourcing framework for transcribing handwritten or OCR-resistant documents."
  field  :description,       type: String, default: "Scribe is particularly geared toward digital humanities, library, and citizen science projects seeking to extract highly structured, normalizable data from a set of digitized materials (e.g. historical manuscripts, account ledgers, or maritime logbooks) in order to enable further analysis, metadata enrichment, and discovery. Scribe is not a crowdsourcing project in a box, but it establishes the foundation for a developer to configure and launch a project far more easily than if starting from scratch."
  field  :keywords,          type: String, default: "transcription, digital humanities, citizen science, crowdsourcing, metadata"
  field  :home_page_content, type: String, default: "<p>There is currently no content on the home page.</p>"
  field  :organizations,     type: Array,  default: []
  field  :scientists,        type: Array,  default: []
  field  :developers,        type: Array,  default: []
  field  :pages,             type: Array,  default: []
  field  :menus,             type: Hash,   default: {}
  field  :partials,          type: Hash,   default: {}
  field  :logo,              type: String
  field  :background,        type: String
  field  :favicon,           type: String
  field  :forum,             type: Hash
  field  :feedback_form_url, type: String
  field  :discuss_url,       type: String
  field  :blog_url,          type: String
  field  :privacy_policy,    type: String
  field  :styles,            type: String
  field  :custom_js,         type: String
  field  :admin_email,       type: String
  field  :team_emails,       type: Array
  field  :metadata_search,   type: Hash
  field  :tutorial,          type: Hash
  field  :terms_map,         type: Hash, default: {} # Hash mapping internal terms to project appropriate terms (e.g. 'group'=>'ship')
  field  :status,            type: String, default: 'inactive'
  field  :analytics,          type: Hash

  # 10.27.15 until we can sort out a better time to call this method, lets comment it out.
  include CachedStats
  update_interval 300

  has_many :groups, dependent: :destroy
  has_many :subject_sets
  has_many :workflows, dependent: :destroy, order: "order ASC"
  has_many :subjects

  scope :most_recent, -> { order(updated_at: -1) }
  scope :active, -> { where(status: 'active') }

  index "status" => 1

  def activate!
    return if self.status == 'active'

    self.class.active.each do |p|
      p.update_attributes status: 'inactive'
    end
    self.update_attributes status: 'active'
  end

  def self.current
    active.first
  end

  def calc_stats
    # amount of days to calculate statistics for
    range_in_days = 7
    datetime_format = "%Y-%m-%d %H:00"

    # determine date range
    current_time = Time.now.utc # Time.new
    end_date = current_time
    start_date = end_date - range_in_days.days

    # calculate total counts
    total_users = User.count
    total_subjects = Subject.count
    total_classifications = Classification.count

    users_data = []
    
    # retrieve subject statuses by workflow:
    workflow_counts = {}
    workflows.each do |workflow|
      workflow_counts[workflow.name] = {total: workflow.subjects.count, data: []}
      groups = Subject.group_by_field(:status, {workflow_id: workflow.id})
      groups.each do |(v, count)|
        workflow_counts[workflow.name][:data] << { label: v, value: count }
        workflow_counts[workflow.name]['id'] = workflow.id
      end
    end

    classifications_data = []

    mark_count = 0
    transcribe_count = 0

    transcribe_count = Classification.where(:workflow => Workflow.where(:name => "transcribe").first.id).count
    mark_count = Classification.where(:workflow => Workflow.where(:name => "mark").first.id).count
    verify_count = Classification.where(:workflow => Workflow.where(:name => "verify").first.id).count

    {
      updated_at: current_time.strftime(datetime_format),
      start_date: start_date.strftime(datetime_format),
      end_date: current_time.strftime(datetime_format),
      users: {
        count: total_users,
        data: users_data
      },
      workflow_counts: workflow_counts,
      classifications: {
        count: total_classifications,
        data: classifications_data
      },
      completion_data: {
        marks: mark_count,
        transcribes: transcribe_count,
        verifies: verify_count
      },
      graphable_data: [
        {
          label: "mark",
          value: mark_count,
        },
        {
          label: "transcribe",
          value: transcribe_count,
        },
        {
          label: "verify",
          value: verify_count,
        },
        {
          label: "unprocessed",
          value: total_subjects - mark_count - transcribe_count - verify_count
        }
      ]
    }
  end

end
