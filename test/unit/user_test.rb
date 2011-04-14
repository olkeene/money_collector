require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def new_user(attributes = {})
    attributes[:username] ||= 'foo'
    attributes[:email] ||= 'foo@example.com'
    attributes[:password] ||= 'abc123'
    attributes[:password_confirmation] ||= attributes[:password]
    user = User.new(attributes)
    user.valid? # run validations
    user
  end

  def setup
    User.delete_all
  end

  should "be valid" do
    assert new_user.valid?
  end

  should "require username" do
    assert_equal ["can't be blank"], new_user(:username => '').errors[:username]
  end

  should "require password" do
    assert_equal ["can't be blank"], new_user(:password => '').errors[:password]
  end

  should "require well formed email" do
    assert_equal ["is invalid"], new_user(:email => 'foo@bar@example.com').errors[:email]
  end

  should "validate uniqueness of email" do
    new_user(:email => 'bar@example.com').save!
    assert_equal ["has already been taken"], new_user(:email => 'bar@example.com').errors[:email]
  end

  should "validate uniqueness of username" do
    new_user(:username => 'uniquename').save!
    assert_equal ["has already been taken"], new_user(:username => 'uniquename').errors[:username]
  end

  should "not allow odd characters in username" do
    assert_equal ["should only contain letters, numbers, or .-_@"], new_user(:username => 'odd ^&(@)').errors[:username]
  end

  should "validate password is longer than 3 characters" do
    assert_equal ["is too short (minimum is 4 characters)"], new_user(:password => 'bad').errors[:password]
  end

  should "require matching password confirmation" do
    assert_equal ["doesn't match confirmation"], new_user(:password_confirmation => 'nonmatching').errors[:password]
  end

  should "generate password hash and salt on create" do
    user = new_user
    user.save!
    assert user.password_hash
    assert user.password_salt
  end

  should "authenticate by username" do
    user = new_user(:username => 'foobar', :password => 'secret')
    user.save!
    assert_equal user, User.authenticate('foobar', 'secret')
  end

  should "authenticate by email" do
    user = new_user(:email => 'foo@bar.com', :password => 'secret')
    user.save!
    assert_equal user, User.authenticate('foo@bar.com', 'secret')
  end

  should "not authenticate bad username" do
    assert_nil User.authenticate('nonexisting', 'secret')
  end

  should "not authenticate bad password" do
    new_user(:username => 'foobar', :password => 'secret').save!
    assert_nil User.authenticate('foobar', 'badpassword')
  end
end
