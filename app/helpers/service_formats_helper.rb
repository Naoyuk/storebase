module ServiceFormatsHelper
  def service_format_title(service)
    content_tag :h1, class: 'service-format-title' do
      concat 'Formats'
      concat content_tag(:span, ' for ', class: 'title-small')
      concat content_tag(:span, "#{service.name} (#{service.platform.name})", class: 'service-format-name')
    end
  end
end
