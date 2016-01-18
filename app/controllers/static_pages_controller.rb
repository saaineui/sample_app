class StaticPagesController < ApplicationController

  def home
      @links = ['help','about']
  end

  def help
      @links = ['home','about']
  end

  def about
      @links = ['home','help']
  end
end
