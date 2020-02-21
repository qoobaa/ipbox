module OcticonHelper
  def octicon(name)
    Octicons::Octicon.new(name).to_svg.html_safe
  end
end
