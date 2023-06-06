module SiteHelper
  def feature_link_to(path, icon, text)
    classes = %w[nav-link]
    classes << "active" if params[:feat] == path

    link_to("/dashboard?feat=#{path}", class: classes) do
      tag.span(class: "align-text-bottom") { icon } + tag.span { text }
    end
  end

  def dashboard_features(features)
    res = []
    prev_pf = nil
    features.each do |f|
      pf = f.service.platform
      if prev_pf.nil?
        res << tag.li(pf.name, class: "platform p-2")
      elsif prev_pf != pf.id
        res << tag.li(pf.name, class: "platform p-2")
      end
      prev_pf = pf.id
      res << tag.li(feature_link_to("#{f.service.platform.name.downcase}-#{f.service.url}", f.service.icon, f.service.name))
    end
    res
  end
end
