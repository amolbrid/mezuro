require 'kalibro_gem/errors'

Given(/^I am at the All Projects page$/) do
  visit projects_path
end

Given(/^I have a sample project$/) do
  @project = FactoryGirl.create(:project, {id: nil})
end

Given(/^I have a project named "(.*?)"$/) do |name|
  @project = FactoryGirl.create(:project, {id: nil, name: name})
end

Given(/^I own a sample project$/) do
  @project = FactoryGirl.create(:project, {id: nil})
  FactoryGirl.create(:project_ownership, {user_id: @user.id, project_id: @project.id})
end

Given(/^I own a project named "(.*?)"$/) do |name|
  @project = FactoryGirl.create(:project, {id: nil, name: name})
  FactoryGirl.create(:project_ownership, {user_id: @user.id, project_id: @project.id})
end

Given(/^I am at the Sample Project page$/) do
  visit project_path(@project.id)
end

Given(/^I am at the sample project edit page$/) do
  visit edit_project_path(@project.id)
end

Given(/^I visit the sample project edit page$/) do
  visit edit_project_path(@project.id)
end

Given(/^I am at the New Project page$/) do
  visit new_project_path
end

Then(/^I should not see (.+)$/) do |text|
  page.should_not have_content(text)
end

#FIXME: this is step is not matched
Then(/^I should not see "(.+)"" within "(.+)"$/) do |text, selector|
  page.find(selector).should_not have_content(text)
end

Then(/^the sample project should be there$/) do
  page.should have_content(@project.name)
  page.should have_content(@project.description)
end

Then(/^I should be in the All Projects page$/) do
  page.should have_content("Projects")
end

Then(/^I should be in the Edit Project page$/) do
  page.should have_content("Edit Project")
end

Then(/^I should be in the Sample Project page$/) do
  page.should have_content(@project.name)
  page.should have_content(@project.description)
end

Then(/^I should be in the Login page$/) do
  page.should have_content("Sign in")
end

Then(/^the sample project should not be there$/) do
  expect { Project.find(@project.id) }.to raise_error 
end

Then(/^The field "(.*?)" should be filled with the sample project "(.*?)"$/) do |field, value|
  page.find_field(field).value.should eq(@project.send(value))
end
