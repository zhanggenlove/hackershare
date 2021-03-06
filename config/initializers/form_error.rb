# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance_tag|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at("input,select,textarea")

  model = instance_tag.object

  html = if field
    attr = instance_tag.instance_eval { @method_name }
    error_msg = model.errors.find { |x, _y| x.to_s == attr }.join(" ")
    field["class"] = "#{field['class']} invalid"
    html = <<-HTML
              #{fragment}
              <p class="text-red-500 text-xs italic">#{error_msg}</p>
           HTML
    html
  else
    html_tag
  end

  html.html_safe
end
