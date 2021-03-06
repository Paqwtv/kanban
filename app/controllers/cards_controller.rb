class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]
  before_action :set_column, only: [:index, :create, :new]

  def index
    @cards = Card.all
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = @column.cards.build(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to root_path, notice: 'No HTML allowed' }
        format.json { render :show, status: :created, location: @card }
      else
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to root_path, notice: 'No HTML allowed' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'No HTML allowed' }
      format.json { head :no_content }
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def set_column
    @column = Column.find(params[:column_id])
  end

  def card_params
    params.require(:card).permit(:title, :column_id, :position)
  end
end
