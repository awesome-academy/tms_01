module ApplicationHelper
  def full_title page_title = ""
    base_title = I18n.t "helpers.application_helper.title"
    page_title.blank? ? base_title : page_title + " | " + base_title
  end
end
