+{
    "WebApp/Sample"  => '<: $dist.path :>',
    "WebApp::Sample" => '<: $dist.module :>',
    "WebApp-Sample"  => '<: $dist.name :>',
    "webapp_sample"  => '<: $dist.join_with("_") | lower :>',
    "WEBAPP_SAMPLE"  => '<: $dist.join_with("_") | upper :>',
    "webapp.sample"  => '<: $dist.join_with(".") | lower :>',
};
