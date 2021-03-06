module Unsakini
  #Ensure user has access to the board and sets the `@board` variable in the controller

  module BoardOwnerControllerConcern
    extend ActiveSupport::Concern

    #Ensure user has access to the board and sets the `@board` variable in the controller
    def ensure_board
      board_id = params[:board_id] || params[:id]
      result = has_board_access(board_id)
      @board = result[:board]
      @user_board = result[:user_board]
      head result[:status] if result[:status] != :ok
    end

    # Validate if user has access to board
    #
    # @param board_id [Integer] board id
    def has_board_access(board_id)
      board = nil
      if !board_id.nil?
        board = Unsakini::Board.find_by_id(board_id)
      else
        return {status: :bad_request}
      end
      if (board)
        user_board = Unsakini::UserBoard.where(user_id: @user.id, board_id: board_id).first
        return {status: :forbidden } if user_board.nil?
        return {status: :ok, board: board, user_board: user_board}
      else
        return {status: :not_found}
      end
    end

    #Ensures user is owner of the board. Must be run after {#ensure_board} method.
    def ensure_board_owner
      render json: {}, status: :forbidden if !@user_board.is_admin
    end

  end

end
