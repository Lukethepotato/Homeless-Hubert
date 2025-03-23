extends Node2D
#Jermey can you put an enum here for the states of movment
#and make the animation player play them based on them
#make sure to make him idle when hes in a fight by using the global autoload
#dont want to make hubert move left and right during the enemys turn

# What the fuck does this mean Luke? You need to explain this verbally.

#im sowwy
##────────█████─────────────█████
#────████████████───────████████████
#──████▓▓▓▓▓▓▓▓▓▓██───███▓▓▓▓▓▓▓▓▓████
#─███▓▓▓▓▓▓▓▓▓▓▓▓▓██─██▓▓▓▓▓▓▓▓▓▓▓▓▓███
#███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███
#██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██
#██▓▓▓▓▓▓▓▓▓──────────────────▓▓▓▓▓▓▓▓██
#██▓▓▓▓▓▓▓─██───████─█──█─█████─▓▓▓▓▓▓██
#██▓▓▓▓▓▓▓─██───█──█─█──█─██────▓▓▓▓▓▓██
#███▓▓▓▓▓▓─██───█──█─█──█─█████─▓▓▓▓▓▓██
#███▓▓▓▓▓▓─██───█──█─█──█─██────▓▓▓▓▓▓██
#─███▓▓▓▓▓─████─████─████─█████─▓▓▓▓███
#───███▓▓▓▓▓──────────────────▓▓▓▓▓▓███
#────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
#─────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
#───────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████
#──────────████▓▓▓▓▓▓▓▓▓▓▓▓████
#─────────────███▓▓▓▓▓▓▓████
#───────────────███▓▓▓███
#─────────────────██▓██
#──────────────────███
#────────█████─────────────█████
#────████████████───────████████████
#──████▓▓▓▓▓▓▓▓▓▓██───███▓▓▓▓▓▓▓▓▓████
#─███▓▓▓▓▓▓▓▓▓▓▓▓▓██─██▓▓▓▓▓▓▓▓▓▓▓▓▓███
#███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███
#██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██
#██▓▓▓▓───────────────────────────▓▓▓▓██
#██▓▓─███──█─████─█───█─████─█████──▓▓██
#██▓▓─██─█─█─█────█───█─█────█──██──▓▓██
#██▓▓─██─█─█─████─██─██─████─████───▓▓██
#██▓▓─██─█─█─█─────███──█────█──██──▓▓██
#██▓▓─██──██─████───█───████─█──███─▓▓██
#─██▓▓▓───────────────────────────▓▓▓███
#───███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███
#────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
#─────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
#───────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████
#──────────████▓▓▓▓▓▓▓▓▓▓▓▓████
#─────────────███▓▓▓▓▓▓▓████
#───────────────███▓▓▓███
#─────────────────██▓██
#──────────────────███
#────────█████─────────────█████
#────████████████───────████████████
#──████▓▓▓▓▓▓▓▓▓▓██───███▓▓▓▓▓▓▓▓▓████
#─███▓▓▓▓▓▓▓▓▓▓▓▓▓██─██▓▓▓▓▓▓▓▓▓▓▓▓▓███
#███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███
#██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██
#██▓▓▓▓▓▓▓────────────────────▓▓▓▓▓▓▓▓██
#██▓▓▓▓▓───████▄─███─████─█████──▓▓▓▓▓██
#███▓▓▓▓───██──█──█──█────█──────▓▓▓▓███
#███▓▓▓▓───██──█──█──████─█████──▓▓▓▓███
#─███▓▓▓───██──█──█──█────────█──▓▓▓▓██
#──████▓───████▀─███─████─█████──▓████
#───███▓▓───────────────────── ▓▓▓███
#────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
#─────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
#───────████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
#──────────████▓▓▓▓▓▓▓▓▓▓▓████
#─────────────███▓▓▓▓▓▓▓███
#───────────────███▓▓▓███
#─────────────────██▓██
#──────────────────███
#
#In 1963, a man named Dukeness Test fell into a coma where they boiled his brain in a machine to create a dog named Dukey the Dog, who 
#became a scientist and mentor of a child named Johnathan Test. This coma game birth to the show Futurama in which he became a red-haired 
#boy named Philip J. Fry. Philip J. Fry hit his head on the cryogenic containment chamber, turning him into a dream world where he became 
#a yellow and orange haired boy named Chuckie Finster. Chuckie Finster is a Layer 2 dreamer. Chuckie Finster has a peanut allergy which 
#causes him to break out into hives and enter a dream coma world where he is in the world of Peanuts as Charlie Brown, but Charlie Brown's
#dream world manifests a dog named Snoopy who is actually the Layer 4 dream version of Dukeness Test, who became Dukey the Dog. Snoopy 
#broke the cycle because he realized he was Dukey, so he went back in time with his other self known as Snoopy to cause Dukeness Test's 
#brain to never be boiled and him to never become Dukey the Dog, erasing him from the timeline, but this causes trouble as Dukey the Dog 
#needed to be a dog in order to finish the very strange machine, because if he did not, the machine becomes unstable and he becomes 
#Ghostly Dukey. Ghostly Dukey goes into a dream coma world where he believes he is a dog named Scooby who solves mysteries about ghosts. 
#Scooby-Doo re- then realizes that he is the dog reincarnation for Layer 5, and goes back in time to stop Layer 2 and Layer 4 Dukeys from 
#going back in time in the first place and reinsuring that he becomes Dukey the Dog in the future. Meanwhile, Timothy Turner is the 
#original dreamer. DO NOT GO TO DREAM LAYER 6. Or else you will meet with a dastardly creature known as Old Man Dookenquences...

# हेलो मैं तुम्हें शौचालय में चोदने वाला हूँ
