class EnvelopesController < ApplicationController
  before_action :set_envelope, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /envelopes
  # GET /envelopes.json
  def index
    @envelopes = Envelope.all
    @total_cash = 0
    current_user.envelopes.each do |envelope|
      @total_cash = envelope.cash.to_i + @total_cash
    end
  end

  # GET /envelopes/1
  # GET /envelopes/1.json
  def show
  end

  # GET /envelopes/new
  def new
    @envelope = Envelope.new
  end

  # GET /envelopes/1/edit
  def edit

  end

  # POST /envelopes
  # POST /envelopes.json
  def create
    @envelope = Envelope.new(envelope_params)
    if !@envelope.name.blank?      
      respond_to do |format|
        if @envelope.save
          format.html { redirect_to root_path, notice: 'Envelope was successfully created.' }
          format.json { render :show, status: :created, location: @envelope }
        else
          format.html { render :new }
          format.json { render json: @envelope.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, notice: 'Envelope was not created.', alert: 'A name is required to create a new transaction.'
    end
  end

  # PATCH/PUT /envelopes/1
  # PATCH/PUT /envelopes/1.json
  def update

    if @envelope.user_id == current_user.id
      respond_to do |format|
        if @envelope.update(envelope_params)
          format.html { redirect_to root_path, notice: 'Envelope was successfully updated.' }
          format.json { render :show, status: :ok, location: @envelope }
        else
          format.html { render :edit }
          format.json { render json: @envelope.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: 'Envelope update failed.', notice: 'Envelopes can only be edited by their creator.'
    end
  end

  # DELETE /envelopes/1
  # DELETE /envelopes/1.json
  def destroy
    if @envelope.user_id == current_user.id
      @envelope.destroy
      respond_to do |format|
        format.html { redirect_to envelopes_url, notice: 'Envelope was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, alert: 'Envelope deletion failed.', notice: 'Envelopes can only be deleted by their creator.'
    end
  end

  def modcash


    @addmoney = params[:cash]
    if params[:commit] == 'Income'

      if @addmoney.blank?
        redirect_to root_path, notice: 'No income assigned to envelopes. Please input amount.'
      else  
          #setup Variables    
          #@total = Envelope.sum('precent')
        @envelopes = Envelope.all


        #Get total of user percents
        current_user.envelopes.each do |envelope|
          @total = @total.to_i + envelope.precent.to_i
        end

        #Add total to total of connected user percents
      #    current_user.friends.envelopes.each do |envelope|
      #      @total = @total+ envelope.precent
      #    end

        #Update cash on all envelopes on current user.
        current_user.envelopes.each do |envelope|
          @money = 0
          @money = envelope.cash.to_i + @addmoney.to_f * (envelope.precent.to_f/@total.to_f)
          envelope.update_attributes :cash => @money.to_i
        end

        #update Cash on all envelopes of connected users.
      #    @envelopes.each do |envelope|
      #     #@envelope = Envelope.find(params[:id])
      #     #@money = @money*((envelope.precent*@total)/10000)
      #     @money = 0
      #     @money = envelope.cash + @addmoney.to_f * (envelope.precent.to_f/@total.to_f)
      #     #@money = (envelope.precent.to_f/@total.to_f)*100
      #     envelope.update_attributes :cash => @money.to_f
      #    end
        redirect_to root_path, notice: 'Income distributed to all envelopes.'
      end
    else
      if @addmoney.blank? || @addmoney.to_i == 0
        redirect_to root_path, notice: 'No expense applied to envelope. Please input amount.'
      else
        @envelope = Envelope.find_by_id(params[:commit])
        if @envelope.user_id == current_user.id
          @envelope.update_attributes :cash => @envelope.cash - @addmoney.to_i

          ###CREATE A NEW TRANSACTION
          @transaction = @envelope.transactions.build(:name => "?", :cash => @addmoney.to_i)#(transaction_params)#(params[:transaction])
          @transaction.save
      
          redirect_to root_path, notice: 'Expense applied to envelope.'
        else
          redirect_to root_path, alert: 'Envelope unmodified', notice: 'Envelopes can only be modified by their creator.'
        end
      end
    end

    #get all envelopes of current user
    #get all envelopes of current user's partner
    #Add up all envelopes Percentages
    #devide up the money acordingly
      #money to give envelope = money *(stated percentage of envelope*All percentages added up / 10000)
    #update attribute on each of those envelopes
  end

  def clear

  #setup Variables    
    @envelopes = Envelope.all

  #user percents
#    current_user.friendships.envelopes.each do |envelope|
#      
#    end

  #envelopes on current user.
    current_user.envelopes.each do |envelope|
      envelope.update_attributes :cash => 0
    end

    redirect_to root_path
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_envelope
      @envelope = Envelope.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def envelope_params
      params.require(:envelope).permit(:name, :color, :icon, :precent, :cash, :user_id).merge(:user_id => current_user.id)
    end
end
