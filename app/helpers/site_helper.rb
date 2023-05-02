module SiteHelper
  def feature_link_to(path, icon, text)
    classes = %w[nav-link]
    classes << "active" if current_page?(path)

    link_to(path, class: classes) do
      tag.span(class: "align-text-bottom") { icon } + tag.span { text }
    end
  end
end
