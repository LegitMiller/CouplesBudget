class TransactionsController < ApplicationController
  def create
  	@envelope = Envelope.find(params[:envelope_id])
      if !Transaction.find_by_id(params[:commit]).blank?
        @transaction = @envelope.transactions.find(params[:commit])
        if @transaction.update(transaction_params)
          redirect_to  edit_envelope_path(@envelope), notice: 'Transaction was successfully updated.'
        else
          redirect_to  edit_envelope_path(@envelope), notice: 'Transaction was not updated'
        end
      else
        @transaction = @envelope.transactions.build(transaction_params)#(params[:transaction])
        if !@transaction.cash.blank?
          @transaction.save
          @envelope.update_attributes :cash => @envelope.cash - @transaction.cash
          redirect_to edit_envelope_path(@envelope)
        else
          redirect_to edit_envelope_path(@envelope), notice: 'Transaction was not created.', alert: 'A cost amount is required to record a new transaction.'
        end
      end
      
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @envelope = Envelope.find_by_id(params[:envelope_id])
    @transaction.destroy
    redirect_to edit_envelope_path(@envelope), notice: 'Transaction was successfully removed.'
  end

  def update
    @transaction = @envelope.transactions.find(params[:id])
    if @transaction.update(transaction_params)
      redirect_to  edit_envelope_path(@envelope), notice: 'Transaction was successfully updated.'
    else
      redirect_to  edit_envelope_path(@envelope), notice: 'Transaction was not updated'
    end
  end

  def edittrans
     respond_to do |format|
        if @envelope.update(envelope_params)
          format.html { redirect_to root_path, notice: 'Envelope was successfully updated.' }
          format.json { render :show, status: :ok, location: @envelope }
        else
          format.html { render :edit }
          format.json { render json: @envelope.errors, status: :unprocessable_entity }
        end
      end
  end

  def transaction_params
    params.require(:transaction).permit(:cash, :name, :envelope_id)#.merge(:envelope_id => :envelope_id)
  end
end
