# frozen_string_literal: true

class StaticPagesController < ApplicationController
  GUIDE_URL = 'https://docs.google.com/document/d/1rNjei4GOOAiDBk4p9EP4ipvmTcq2jJxaY-bIR8XUCVw/edit?usp=sharing'
  CLAIM_FORM_URL = 'http://tinyurl.com/committs'

  def guide
    redirect_to GUIDE_URL
  end

  def claim_form
    redirect_to CLAIM_FORM_URL
  end

  def grab_duty; end
end
