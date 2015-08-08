# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  # I have to recreate some string keys to dynamically interpolate endpoints
  # on SearchSuggestions urls.
  # The scope is probably very big.
  # TODO: refactor string interpolation so memory footprints are smaller
  base_path = '/search_suggestions'
  company_names_key = 'job_tracker:company_names'
  contact_names_key = 'job_tracker:contact_names'

  $('#contact_company_name, #job_application_company_name').autocomplete
    source: "#{base_path}?parent_set=#{company_names_key}"
  $('#interaction_contact_name').autocomplete
    source: "#{base_path}?parent_set=#{contact_names_key}"
