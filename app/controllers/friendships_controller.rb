# frozen_string_literal: true

class FriendshipsController < ApplicationController
  def destroy
    current_user.friendships.where(friend_id: params[:id]).first.destroy
    respond_to do |format|
      format.html { redirect_to my_friends_path, notice: 'Friend was removed' }
    end
  end
end
