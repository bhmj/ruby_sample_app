require 'pcalc'

class StaticPagesController < ApplicationController

  def home
    d = case params[:precision]
    when '0'
      :d_0
    when '2'
      :d_2
    when 'float'
      :d_float
    else
      :d_0
    end
    pc = PolandCalculator.new do
      decimal_selector d
    end
    @result = pc.calc(params[:q])
    rescue StandardError => err
      @result = err.to_s
  end

  def help
  end

  def contact
  end

end
