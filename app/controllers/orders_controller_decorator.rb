OrdersController.class_eval do

  skip_before_filter :check_authorization, :only => [:claim]

  def claim
    order = Order.find_by_number params[:id]
    authorize! :assign_to_rightful_owner, order
    if order.assign_to_rightful_owner
      flash[:notice] = t('order_claim_success')
    else
      flash[:error] = t('order_claim_failure')
    end
    redirect_to account_path
  end

end