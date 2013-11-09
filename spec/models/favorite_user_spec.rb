require 'spec_helper'

describe FavoriteUser do
  fixtures(:all)

  describe 'create' do
    context 'given valid attributes' do
      subject { FavoriteUser.create(:user_id => 101, :favorite_user_id => 102) }
      it { expect(subject).to be_valid }
    end
    context 'already registered' do
      subject { FavoriteUser.create(:user_id => 1, :favorite_user_id => 2) }
      it { expect(subject).not_to be_valid }
    end
    context 'not give any values' do
      subject { FavoriteUser.new() }
      it { expect { subject.save }.to raise_error(ActiveRecord::StatementInvalid) }
    end
    context 'not given favorite user id' do
      subject { FavoriteUser.new(:user_id => 1) }
      it { expect { subject.save }.to raise_error(ActiveRecord::StatementInvalid) }
    end
    context 'not given user id' do
      subject { FavoriteUser.new(:favorite_user_id => 1) }
      it { expect { subject.save }.to raise_error(ActiveRecord::StatementInvalid) }
    end
    context 'given unknown attribute' do
      subject { FavoriteUser.new(:unknown => 1) }
      it { expect { subject.save }.to raise_error(ActiveRecord::UnknownAttributeError) }
    end
  end

  describe 'destroy' do
    before do
      @user = User.find_by_id(1)
    end
    context 'destroy exists data' do
      subject { @user.favorite_users.find_by_favorite_user_id(2).destroy }
      it { expect(subject).to be_valid }
    end
    context 'destroy not exists data' do
      subject { @user.favorite_users.find_by_favorite_user_id(100).destroy }
      it { expect { subject }.to raise_error(NoMethodError) }
    end
  end

end
