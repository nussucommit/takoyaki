# frozen_string_literal: true

module ApplicationHelper
  # Helper to choose foreground colour from a given background colour
  # following W3C Recommendation https://www.w3.org/TR/WCAG20/#relativeluminancedef
  def choose_fgcolour(bgcolour)
    r, g, b = srgb_to_linearrgb(bgcolour)
    luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
    luminance > 0.179 ? '#000000' : '#FFFFFF'
  end

  private

  def srgb_to_linearrgb(colour)
    r, g, b = colour.match(/#(..)(..)(..)/).to_a.drop(1).map do |e|
      a = e.hex / 255
      a <= 0.03928 ? a / 12.92 : ((a + 0.055) / 1.055)**2.4
    end
    [r, g, b]
  end
end
