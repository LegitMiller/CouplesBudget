class TransactionsController < ApplicationController
  def create
  	@envelope = Envelope.find(params[:envelope_id])

      #Edit existing    
      if !Transaction.find_by_id(params[:commit]).blank?
        @transaction = @envelope.transactions.find(params[:commit])
        @oldcash = @transaction.cash
        if @transaction.update(transaction_params)
          @envelope.update_attributes :cash => @envelope.cash.to_i + (@oldcash.to_i - @transaction.cash.to_i )
          redirect_to  edit_envelope_path(@envelope), notice: 'Transaction and Envelope total were successfully updated.'
        else
          redirect_to  edit_envelope_path(@envelope), notice: 'Transaction was not updated'
        end
      #create New
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
    @envelope.update_attributes :cash => @envelope.cash + @transaction.cash
    @transaction.destroy
    redirect_to edit_envelope_path(@envelope), notice: 'Transaction was successfully removed.'
  end



  def transaction_params
    params.require(:transaction).permit(:cash, :name, :envelope_id)#.merge(:envelope_id => :envelope_id)
  end
end
