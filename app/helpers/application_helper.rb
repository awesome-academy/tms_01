module ApplicationHelper
  def full_title page_title = ""
    base_title = I18n.t "helpers.application_helper.title"
    page_title.blank? ? base_title : page_title + " | " + base_title
  end

  def format_date datetime
    datetime.strftime I18n.t(".format_time")
  end

  def will_paginate_helper objects
    will_paginate(objects,
      renderer: WillPaginate::ActionView::Bootstrap4LinkRenderer,
      class: "justify-content-center mb-5")
  end
end
