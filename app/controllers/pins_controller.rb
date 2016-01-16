class PinsController < ApplicationController
  
  def index
    @pins = Pin.all
    @pin = Pin.find_by_slug(params[:slug])
  end

  def show_by_name
  	@pin = Pin.find_by_slug(params[:slug])
  	render :show
  end

  def show
    @pin = Pin.find(params[:id])
  end

  def new
    @pin = Pin.new
  end
 
end