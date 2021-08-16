<?php
	include_once("includes/db.php");
	include_once("settings.php");
    $db = new database();
  // in case it runs from gen_rss.php it's using $cur_lang variable
  $lang = isset($lang) ? $lang : $cur_lang; // $lang or $cur_lang : '', '_au', '_fr', '_it'

  $ENTER_EMAIL = $obj->getTranslation("ENTER_EMAIL", $lang);
  $SUBSCRIBE = $obj->getTranslation("SUBSCRIBE", $lang);
  $FEED = $obj->getTranslation("FEED", $lang);
  $FILLED_UNDER = $obj->getTranslation("FILLED_UNDER", $lang);

  // RSS features
  $RSS_TITLE = $obj->getTranslation("RSS_TITLE", $lang);
  $RSS_DESCRIPTION = $obj->getTranslation("RSS_DESCRIPTION", $lang);
  $RSS_LANG = $obj->getTranslation("RSS_LANG", $lang);
  $RSS_COPYRIGHT = $obj->getTranslation("RSS_COPYRIGHT", $lang);
  
  // subscribe
  $READ_MORE_NEWS = $obj->getTranslation("READ_MORE_NEWS", $lang);
  $UNSUBSCRIBE = $obj->getTranslation("UNSUBSCRIBE", $lang);
  //$UNSUBSCRIBED = $obj->getTranslation(10, $lang, "email_templates", "id");
  $UNSUBSCRIBED = $obj->getTranslation("UNSUBSCRIBED", $lang, "email_templates", "subject");

  // Footer menu texts
  $HOME = $obj->getTranslation("HOME", $lang);
  $WHATS_NEW = $obj->getTranslation("WHATS_NEW", $lang);
  $TRIBES = $obj->getTranslation("TRIBES", $lang);
  $DISCOVER = $obj->getTranslation("DISCOVER", $lang);
  $MEMBERS = $obj->getTranslation("MEMBERS", $lang);
  $FEEDBACK = $obj->getTranslation("FEEDBACK", $lang);
  $PLAY = $obj->getTranslation("PLAY", $lang);
  $FOOTER_COPYRIGHT = $obj->getTranslation("FOOTER_COPYRIGHT", $lang);
    
  $MORE = $obj->getTranslation("MORE", $lang);
  $PAGES = $obj->getTranslation("PAGES", $lang);
  
  // drop-down list of feedback types in feedback form 
  $FEEDBACK_OPTION_1 = $obj->getTranslation("FEEDBACK_OPTION_1", $lang);
  $FEEDBACK_OPTION_2 = $obj->getTranslation("FEEDBACK_OPTION_2", $lang);
  $FEEDBACK_OPTION_3 = $obj->getTranslation("FEEDBACK_OPTION_3", $lang);
  $FEEDBACK_OPTION_4 = $obj->getTranslation("FEEDBACK_OPTION_4", $lang);

?>