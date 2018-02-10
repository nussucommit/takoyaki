module UsersHelper
  def role_adder(role)
  	if params[role] == "1"
    	@user.add_role(role)
  	elsif params[role] == "0"
    	@user.remove_role(role)
  	end
  end
end
