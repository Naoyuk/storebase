module SiteHelper
  def feature_link_to(path, emoji, text)
    classes = %w[nav-link]
    classes << "active" if current_page?(path)

    link_to(path, class: classes) do
      tag.span(class: "align-text-bottom") { emoji } + tag.span { text }
    end
  end
end
