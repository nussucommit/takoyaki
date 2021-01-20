# frozen_string_literal: true

class StaticPagesController < ApplicationController
  GUIDE_URL = 'https://docs.google.com/document/d/1JP3GL9Zm7l6Gw6uiZ5isdygBBXMe5S5v3aoaYBskjGE/edit'
  CLAIM_FORM_URL = 'http://tinyurl.com/committs'

  def guide
    redirect_to GUIDE_URL
  end

  def claim_form
    redirect_to CLAIM_FORM_URL
  end

  def grab_duty; end
end
