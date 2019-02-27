class ColumnsController < ApplicationController
  before_action :set_column, only: [:show, :edit, :update, :destroy]
  before_action :set_board, only: [:index, :create, :new]

  def index
    @columns = Column.all
  end

  def show
  end

  def new
    @column = Column.new
  end

  def edit
  end

  def create
    @column = @board.columns.build(column_params)

    respond_to do |format|
      if @column.save
        format.html { redirect_to root_path, notice: 'No HTML allowed for ths path' }
        format.json { render :show, status: :created, location: @column }
      else
        format.html { render :new }
        format.json { render json: @column.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @column.update(column_params)
        format.html { redirect_to root_path, notice: 'No HTML allowed for ths path' }
        format.json { render :show, status: :ok, location: @column }
      else
        format.html { redirect_to root_path, notice: 'No HTML allowed for ths path' }
        format.json { render json: @column.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @column.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'No HTML allowed for ths path' }
      format.json { head :no_content }
    end
  end

  private

  def set_column
    @column = Column.find(params[:id])
  end

  def set_board
    @board = Board.find_by(uid: params[:board_uid])
  end

  def column_params
    params.require(:column).permit(:title)
  end
end
