# GauchoBack

README

----------
GauchoBack 
----------

Test Run Instructions:
 - Launch: "GauchoBack.xcworkspace"
 - In terminal cd into the folder where the project is stored.
 - Enter the command: "pod install" (Now all of the SDK's are stored on your machine)
 - Now run the program in X-code

App Control Instructions:
 - At the Login page the user has the option of Creating a GauchoBack account, Login with their previously made GauchoBack credentials, or Log in with facebook.
 - Logging in with facebook will redirect the user to the facebook app to request information about the user's Facebook account information.  This Information will be used to create an account, or log in to their account using facebook's credentials.
 - All user's that use facebook to create an account will be using their facebook email as their GauchBack email and facebook id as their password, as well as their first and last name will be stored in a userInfo object stored on Firebase.
 - Firebase is GauchoBack's server system, to store all data items.
 - At the login page the user can proceed to Create account.
 - In the create account page the user can create a firebase account.  There are fields for entering the user's first and last name, but this is optional.  Email and password are required, for account creation.
 - Once the user has logged in or created an account they will be brought to the Map View window.

 - The Map view displays all of the events nearby the user's current location, within the their maximum distance.  
 - The maximum distance variable can be set within the My Account tab.  
 - Events are user created inside the Add Event tab.
 - You can click on a pin to see the event's title, and click on its title to see the event details and its location
 - You can zoom out of your immediate location to look at all the events around campus
 - You can press the button in the bottom right hand corner to take you back to your phone's current location
 
 - In the Search Tab the user can search by a keyword and search type. The search types are: title, description, host, and location
 - Initially, all events will be shown. However, when you click on the search bar at the top, it will let you choose by search type and type in a search query
 - Once the search is done there will be a list of events underneath the search text field that matched what the user searched.
 - After the search has been done the user can click on the event to view the details for the event and see where it's located with a map window.

 - In the Add Event Tab, The user will be presented with a map view of where they currently are if they are currently logged into an account
 - There will be no other pins on the add event map
 - If the user is using view only mode, it will segue them to the login page
 - The user can swipe on the map and navigate to where their event is happening, and drop a pin by doing a long press on the location where it is.  
 - Once the pin has been dropped, the user will be presented with 3 choices for what type of event it is. Warning, Meeting or Event.  
 - Depending on the choice the user makes it will take them to a particular window displaying the available text fields.
 - You can click the preview button in the top right corner to look at a preview of what the event will look like when other users click on it
 - There will be a create button at the bottom, which will store the event onto our Firebase Server, and associate it to the current user.  Meaning it will set the author of the even to the current user.
 - After the event was created the user will be redirected to the Map view to see their new pin and along with the other nearby events.
 -There is a color scheme to each event type.  Blue: Event, Red: Warning, and Yellow: Meeting

 - In the My Account tab the user will see their account settings and all the events they have added to GauchoBack
 - The user will be able to modify their events here by clicking on the event and then clicking the edit button in the top right corner
 - The user will be able to change their password here if they did not use Facebook to create their account.  

 -There will be more added to this, but as of right now this is everything we can think of.

 Domain Analysis: https://docs.google.com/document/d/1c7jndBene1AhU0S6PBw1l5HZ36MROI9XPindBDC1AAY/edit?usp=sharing
