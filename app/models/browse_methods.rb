class BrowseMethods

  def self.show_by_identifier(identifier)

    type = 'root'
    next_page = nil
    prev_page = nil

    puts identifier
    subject = Subject.by_type(type).find_by('meta_data.identifier' => identifier)
    if not subject
      raise ActionController::RoutingError.new('Not Found')
    end

    this_subject_result = Subject.by_type(type).page(1).where('meta_data.identifier' => identifier)
    next_subjects = Subject.by_type(type).where(:order.gt => subject.order.to_i).order(order: :asc)

    if next_subjects.count > 0
      next_page_identifier = next_subjects[0].meta_data[:identifier]
      if next_page_identifier
        next_page = '/view/' + next_page_identifier
      end
    end

    previous_subjects = Subject.by_type(type).where(:order.lt => subject.order.to_i).order(order: :desc)
    if previous_subjects.count > 0
      previous_page_identifier = previous_subjects[0].meta_data[:identifier]
      if previous_page_identifier
        prev_page = '/view/' + previous_page_identifier
      end

    end

    links = {
      "next" => {
        href: next_page
      },
      "prev" => {
        href: prev_page
      }
    }
    subject = this_subject_result
    return subject, links
  end
end
