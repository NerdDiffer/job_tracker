# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  # I have to recreate some string keys to dynamically interpolate endpoints
  # on SearchSuggestions urls.
  # The scope is probably very big.
  # TODO: refactor string interpolation so memory footprints are smaller
  base_path = '/search_suggestions'
  company_names = 'company_names'
  category_names = 'category_names'

  $('#contact_company_name, #job_application_company_name').autocomplete
    source: "#{base_path}?key=#{company_names}"
  $('#company_category_name').autocomplete
    source: "#{base_path}?key=#{company_names}"
