class DogsController < ApplicationController
  before_action :load_dog, except: [:index]

  def index
    @dogs = Dog.includes(:statuses).order(:name).page(params[:page])
  end

  def show
  end

  def create
  end

  def edit
  end

  def update
  end

  private

  def load_dog
    @dog = Dog.find(params[:id])
  end
end