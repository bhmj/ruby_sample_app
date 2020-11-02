class HistoryController < ApplicationController
  def new
  end
  def show
    @hist = History.find(params[:id])
  end
  def index
  end
end
