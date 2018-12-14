# frozen_string_literal: true

class SettingsController < ApplicationController
  load_and_authorize_resource

  def edit
    @settings = Setting.retrieve
  end

  def update
    if Setting.retrieve.update settings_params
      redirect_to edit_settings_path, notice: 'Settings successfully updated!'
    else
      redirect_to edit_settings_path, alert: 'Updating settings failed!'
    end
  end

  private

  def settings_params
    params.require(:setting).permit(:mc_only)
  end
end
