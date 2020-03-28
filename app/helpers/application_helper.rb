module ApplicationHelper
  def inline_svg(path)
    File.open("app/assets/images/#{path}.svg", "rb") { |file| raw file.read }
  end
end
