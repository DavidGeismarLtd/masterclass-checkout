# app/helpers/form_helper.rb
module FormHelper
  def error_message_for(form, field)
    if form.object.errors[field].present?
      content_tag(:p, form.object.errors.full_messages_for(field).join(', '), class: "mt-2 text-sm text-red-600")
    end
  end
end