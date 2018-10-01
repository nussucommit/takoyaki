# frozen_string_literal: true

class StaticPagesController < ApplicationController
  GUIDE_URL = 'https://docs.google.com/document/d/1rNjei4GOOAiDBk4p9EP4ipvmTcq2jJxaY-bIR8XUCVw/edit?usp=sharing'

  def guide
    redirect_to GUIDE_URL
  end

  def grab_duty; end
end
