class UsersController < ApplicationController
	def role_adder(role)
  	  if params[role] == "1"
    	@user.add_role(role)
  	  elsif params[role] == "0"
    	@user.remove_role(role)
  	  end
    end

	def index
		@users= User.all
	end

	def edit
		@user=User.find params[:id]
		@roles = [:admin, :manager, :member]
		
		
	end
	def update
		@user=User.find params[:id]
		@roles = [:admin, :manager, :member]
		@roles.each { |r| role_adder(r) }

		if @user.update(user_params)
			redirect_to users_path
		else
			redirect_to users_path
		end
	end
	def show
		@user=User.find params[:id]
	end
	def destroy
		@user=User.find params[:id]
		@user.destroy
		redirect_to users_path
	end

	private def user_params
		params.require(:user)
		params.require(:roles)
	end
end
