// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('change', 'input[type="file"]', function(e){
    $('label[for="fileSelector"]').text(e.target.files[0].name);
    $('input[type="submit"].-disabled').removeClass('-disabled');
});
