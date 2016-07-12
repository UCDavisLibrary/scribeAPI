class BrowseMethods

  def self.get_by_identifier(identifier)
    subject = Subject.root.page(1).where('meta_data.identifier' => identifier)
    if subject.count() == 0
      raise ActionController::RoutingError.new('Not Found')
    end

    return subject
  end

  def self.browse_by_identifier(identifier)

    next_page = nil
    prev_page = nil

    subject_result = self.get_by_identifier(identifier)
    subject = subject_result[0]

    next_subjects = Subject.root.where(:order.gt => subject.order.to_i).order(order: :asc).limit(1)

    if next_subjects.count > 0
      next_page_identifier = next_subjects[0].meta_data[:identifier]
      if next_page_identifier
        next_page = '/view/' + next_page_identifier
      end
    end

    previous_subjects = Subject.root.where(:order.lt => subject.order.to_i).order(order: :desc).limit(1)
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
    return subject_result, links
  end
end
