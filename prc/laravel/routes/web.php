<?php

use Illuminate\Support\Facades\Route;

// Redirect root to the login page
Route::get('/', function () {
    return redirect('/index.html');
});
