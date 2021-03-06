Given(/^I have a sample configuration with native metrics$/) do
  reading_group = FactoryGirl.create(:reading_group, id: nil)
  reading = FactoryGirl.create(:reading, {id: nil, group_id: reading_group.id})
  range = FactoryGirl.build(:range, {id: nil, reading_id: reading.id, beginning: '-INF', :end => '+INF'})
  @configuration = FactoryGirl.create(:configuration, id: nil)
  metric_configuration = FactoryGirl.create(:metric_configuration,
                                            {id: nil,
                                             metric: FactoryGirl.build(:loc),
                                             reading_group_id: reading_group.id,
                                             configuration_id: @configuration.id})
  range.save metric_configuration.id
end

Given(/^I have a sample repository within the sample project$/) do
  @repository = FactoryGirl.create(:repository, {project_id: @project.id, 
                                                 configuration_id: @configuration.id, id: nil})
end

Given(/^I have a sample repository within the sample project named "(.+)"$/) do |name|
  @repository = FactoryGirl.create(:repository, {project_id: @project.id, 
                                                 configuration_id: @configuration.id, id: nil, name: name})
end

Given(/^I start to process that repository$/) do
  @repository.process
end

Given(/^I wait up for a ready processing$/) do
  unless Processing.has_ready_processing(@repository.id)
    while(true)
      if Processing.has_ready_processing(@repository.id)
        break
      else
        sleep(10)
      end
    end
  end
end

Given(/^I am at the New Repository page$/) do
  visit new_project_repository_path(@project.id)
end

Given(/^I am at repository edit page$/) do
  visit edit_project_repository_path(@repository.project_id, @repository.id)
end

Given(/^I ask for the last ready processing of the given repository$/) do
  @processing = Processing.last_ready_processing_of @repository.id
end

Given(/^I ask for the module result of the given processing$/) do
  @module_result = ModuleResult.find @processing.results_root_id
end

Given(/^I ask for the metric results of the given module result$/) do
  @metric_results = @module_result.metric_results
end

Given(/^I see a sample metric's name$/) do
  page.should have_content(@metric_results.first.metric_configuration_snapshot.metric.name)
end

When(/^I click on the sample metric's name$/) do
  click_link @metric_results.first.metric_configuration_snapshot.metric.name
end

When(/^I set the select field "(.+)" as "(.+)"$/) do |field, text|
  select text, from: field
end

When(/^I visit the repository show page$/) do
  visit project_repository_path(@project.id, @repository.id)
end

When(/^I click on the sample child's name$/) do
  click_link @module_result.children.first.module.name
end

When(/^I click the "(.*?)" h3$/) do |text|
  page.find('h3', text: text).click()
end

When(/^I wait up for the ajax request$/) do
  while (page.driver.network_traffic.last.response_parts.empty?) do
    sleep(10)
  end
end

Then(/^I should see the sample repository name$/) do
  page.should have_content(@repository.name)
end

Then(/^the field "(.*?)" should be filled with "(.*?)"$/) do |field, value|
  page.find_field(field).value.should eq(value)
end

Then(/^I should see the given module result$/) do
  page.should have_content(@module_result.module.name)
end

Then(/^I should see a sample child's name$/) do
  page.should have_content(@module_result.children.first.module.name)
end

Then(/^I should see the given repository's content$/) do
  page.should have_content(@repository.type)
  page.should have_content(@repository.description)
  page.should have_content(@repository.name)
  page.should have_content(@repository.license)
  page.should have_content(@repository.address)
  page.should have_content(@configuration.name)
  page.should have_content("1 day") # The given repository periodicity
end

Then(/^I should see a loaded graphic for the sample metric$/) do
  page.all("img#container" + @metric_results.first.id.to_s)[0].should_not be_nil
end

Then(/^I wait for "(.*?)" seconds or until I see "(.*?)"$/) do |timeout, text|
  start_time = Time.now
  while(page.html.match(text).nil?)
    break if (Time.now - start_time) >= timeout.to_f
    sleep 1
  end 
  
  page.should have_content(text)
end