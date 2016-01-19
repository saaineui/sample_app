class StaticPagesController < ApplicationController

  def home
      @links = ['home','help','login']
  end

  def help
      @links = ['home','help','login']
  end

  def login
      @links = ['home','help','login']
  end
end
