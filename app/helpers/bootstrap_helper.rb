module BootstrapHelper
  BOOTSTRAP_FLASH_CLASSES = {
    notice: "alert-info",
    success: "alert-success",
    error: "alert-danger",
    alert: "alert-danger"
  }

  def bootstrap_class_for(type)
    BOOTSTRAP_FLASH_CLASSES.fetch(type.to_sym, type.to_s)
  end

  def bootstrap_devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |message| content_tag(:li, message) }.join
    sentence = I18n.t(
      'errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase
    )

    html = <<-HTML
    <div class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      <h4 class="alert-heading">#{sentence}</h4>
      <ul class="mb-0">#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def bootstrap_modal_close_button_tag
    button_tag(type: "button", class: "close", aria: {label: "Close"}, data: {dismiss: "modal"}) do
      content_tag(:span, "&times;".html_safe, aria: {hidden: true})
    end
  end

  def bootstrap_invalid_feedback_for(record, attribute)
    content_tag(:div, record.errors[attribute].join(", "), class: "invalid-feedback d-block") #if record.errors[attribute].present?
  end
end
