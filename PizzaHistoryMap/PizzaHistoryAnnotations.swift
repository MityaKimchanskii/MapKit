//
//  PizzaHistoryAnnotations.swift
//  PizzaHistoryMap
//
//  Created by Mitya Kim on 10/14/22.
//  Copyright © 2022 Dmitrii Kim. All rights reserved.
//

import UIKit
import CoreLocation

class PizzaHistoryAnnotations{
    var annotations:[PizzaAnnotation] = []
    init(){
        //Naples
        var annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(40.8367321,14.2468856), title: "Pizza Margherita", subtitle: "Street Food Nationalized")
        annotation.pizzaPhoto = #imageLiteral(resourceName: "Naples")
        annotation.deliveryRadius = 30.0
        annotation.historyText = "Street Food Nationalized - The legend goes that King Umberto and Queen Margherita of Italy got tired of the royal food, which was always French. Looking for both something new and something Italian, in Naples they ordered a local pizzeria to make them pizza, which was up till then poor people's food.  The Queen loved a pizza of tomatoes, fresh mozzarella and basil so much the restaurant named the pizza after her. That the pizza was the colors of the Italian flag may not be a coinicidence. To this day to sell a true Neapolitan pizza, you must be certified by an association of pizza restaurants in Naples for the process and quality of ingredients."
        self.annotations.append(annotation)
        
        //New York
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(40.7216294 , -73.995453), title: "New York Pizza", subtitle: "Pizza Comes to America")
        annotation.pizzaPhoto = #imageLiteral(resourceName: "New York")
        annotation.deliveryRadius = 30.0
        annotation.historyText = "The first known Pizza restaurant in the United States was in New York’s Little Italy. Gennaro Lombardi in 1905 opened his restaurant, but used a coal oven instead of a traditional wood burning oven, since coal was cheaper than wood in New York. New York Pizza breaks several traditions from its Italian ancestor. Most importantly it is sold in large slices, which meant whole pizzas were made larger than the traditional 14inch/35cm diameter. To make a larger pizza, a  higher gluten recipe is used for the crust, and the pizza is tossed in the air with a spinning motion to expand."
        annotations.append(annotation)
        
        //Chicago
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(41.892479 , -87.6267592), title: "Chicago Deep Dish", subtitle: "No more flat crusts")
        annotation.pizzaPhoto = #imageLiteral(resourceName: "Chicago")
        annotation.historyText = " In 1943, Ike Sewell changed the crust from the thin flatbread to a deep pan, adding traditional Italian/New York  ingredients. Sewell and his cook and eventual manager Rudy Malnati added a layer of sausage to the pan. Some believe the longer cooking time of 20 minutes to 45 minutes of the deep dish meant more beverage consumption, and a higher profit for the restaurant. Deep dish pizza caught on in Chicago, with many competitors in the area. With the 2 inch of deeper pizza crust, the order of ingredients can change between competitors, with a crust ranging in texture from cracker like to bread like and the cheese on top or on the sauce on top."
        annotations.append(annotation)
        
        //Chatham
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(42.4056555,-82.1860369), title: "Hawaiian/Canandian Pizza", subtitle: "Non-Italian Ingredients")
        annotation.pizzaPhoto = #imageLiteral(resourceName: "Chatham")
        annotation.deliveryRadius = 60.0
        annotation.historyText = "The so-called Hawaiian pizza is not Hawaiian -- It's Canadian. Greek immigrant  to Canada Sam Panopoulos added canned pineapple and Canadian bacon to a pizza in his small restaurant in Chatham, Canada. This is the one of the earliest pizzas without traditional Italian ingredients. As late as 2017, a few months before Panopoulos' death this was controversial, with purists angry about pineapple on a pizza. The president of Iceland started a near diplomatic incident between Canada and Iceland with his statement he would make pineapple on Pizza illegal if he could, with Canadians up in arms about their treasure."
        annotations.append(annotation)
        //Chicago II
        annotation = PizzaAnnotation(coordinate: CLLocationCoordinate2DMake(41.9206921,-87.6375361), title: "Pizza Pot Pie", subtitle: "Turned on its head")
        annotation.historyText = "Chicago seems to modify the traditional crust more than anywhere that makes pizza. The ultimate example is the Pizza pot pie, baked with the crust on top of the ingredients. The ingredients are placed in a ceramic bowl, the pizza dough placed over the bowl, baked, and then the bowl is inverted into the cooked crust  and removed when served to the guest. This is as far from a Neapolitan pizza in structure as you can get.  Theres one thing here and the street vendors of Naples in the 1800’s have in common: they only accept cash here."
        annotations.append(annotation)
        //Beverly Hills
        annotation = PizzaAnnotation( coordinate: CLLocationCoordinate2DMake(34.0674607,-118.3977309), title: "California Pizza", subtitle: "Is this a pizza?")
        annotation.pizzaPhoto = #imageLiteral(resourceName: "Beverly Hills")
        annotation.historyText = "Californian Fusion cuisine combines elements from many cuisines, and pizza is no exception. Wolfgang Puck hired San Francisco chef Ed LaDou to run the pizza oven at his trendy but exclusive restaurant here when it opened in 1982, and used completely non-traditional ingredients, such as duck sausage and smoked salmon. These pizzas still had a traditional crust. Whlie Queen Margherita may have made it permissible to eat poor peoples food, LaDou made it into rich people’s food."
        annotations.append(annotation)
        //Beverly Hills II
        annotation = PizzaAnnotation(coordinate: CLLocationCoordinate2DMake(34.0647691,-118.3991328), title: "BBQ Chicken Pizza", subtitle: "Fusion for everyone")
      
        annotation.historyText = "Two Los Angles Attorneys, Larry Flax and Rick Rosenfeld were so entranced by Ed LaDou’s pizzas they started a casual dining restaurant with some of LaDou’s creations, including a new one of barbecue sauce and chicken. The restaurant was so successful, it became an chain throughout North America,South America and Asia, popularizing non-Italian and often Asian ingredients in pizza. A national food of Italy becomes a uniquely American food all over the world. Suspiciously, there are no locations in Europe."
        annotations.append(annotation)
    }
}
