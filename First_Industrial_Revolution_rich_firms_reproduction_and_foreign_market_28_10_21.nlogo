;;use in-radius as primitive for local matching
;see if you want to use extensions

;extensions [dist]

; dist is for plotting frequency distributions
;see https://github.com/nicolaspayette/DistExtension#readme
;could be useful to visualize workers per firm

;remember to set number

globals [
  ;there is only one value for global varibles, so no aggregates, more like parameters in matlab
  ;the difference is, you only need these if they are used in multiple procedures
  ;also, if you make a chooser or a switch you do not need to insert the variable here
  Max-Grain ;how much grain can a specific patch have
 ;k, trans-cost as in the amount of capital necessary to transition
  min-price ;minimum price for goods
  minimum ;set a minimum value to be used everywhere when we want to avoid negative numbers
  aggregate-credit
  aggregate-credit-demand
  aggregate-residual-credit
  aggregate-residual-credit-demand
  aggregate-employed
  aggregate-unemployment
  aggregate-farm-production
  aggregate-industry-production
  aggregate-services
  aggregate-goods-demand
  aggregate-services-demand
  aggregate-demand
  aggregate-metabolism
  aggregate-profits
  aggregate-installments
  aggregate-dividends
  average-capital-firms
  average-capital-farms
  average-capital-banks
  industrialized-firms
  failed-firms
  failed-firms-now
  mean-farm-price
  mean-farm-price-t-1
  mean-firm-price
  mean-service-price
  local-number
  industrial-switching-check
  industrial-switching-check2
  industrial-switching-check3
  industrial-switching-check4
  labor-check
  farms-production-check
  firms-production-check
  services-production-check
  demand-check
  farms-market-check
  firms-market-check
  service-market-check
  dividends-check
  price-adjusting-check
  agent-replacement-check
  government-check
  taxes
  kids-number
  new-industries
  unemployed
  employed
  mean-price-farms
  mean-price-firms
  mean-price-services
  mean-salaries
  mean-salaries-firm-workers
  mean-salaries-farm-workers
  mean-salaries-public-workers
  mean-interest-rates
  GDP-income
  GDP-spending
  goods-income-value
  labor-income-value
  land-income-value
  service-income-value
  profit-income-value
  mean-profit-rate
  inflation
  exports
  imports
]
;all global variables must be put in here, as in any variable that repeats more than once

;this creates the category for the different kind of agents
;first is the name of the whole breed, second calls only one member
breed [workers worker]
breed [bourgeoisie bourgeois]
breed [nobility noble]
breed [banks bank]
breed [firms firm]
breed [farms farm]
breed [government gov]
breed [foreign-market foreign]
;breed [BankofEngland boe]

;undirected-link-breed [deps dep]
undirected-link-breed [ownership own]
;undirected-link-breed [debits debit]
;undirected-link-breed [employed employ]

;now assing their characteristics

workers-own [
  wealth           ; the amount of cash at hand a turtle has
  ;life-expectancy  ; maximum age that a turtle can reach, maybe use this?
  metabolism       ; how much grain a turtle eats each time
  needs ;goods
  desires ; services
  unemployed? ; if 1 yes if 0 no
  employed?
  unemployment
  salary
  kids ; after a certain value this is used for reproduction
  change ;this variable is used for trasfering values between parentesys
 ; payed? ;necessary for goods and service, see if you can do that better
  consumption
  firm?
  farm?
  state?
  bonds
  prevmet
]

bourgeoisie-own [
  metabolism
  deposited
  needs
  desires
  service
  wealth
  bonds
  kids
  price
  change
   ; payed? ;necessary for goods and service, see if you can do that better
  consumption
  interest
  industrialized-check
  owned-bonds
  prevmet
  owner?
]

nobility-own [
  metabolism
  needs
  desires
  service
  wealth
  bonds
  kids
  change
  ;  payed? ;necessary for goods and service, see if you can do that better
  consumption
  interest-rate
  owned-bonds
  prevmet
]

firms-own [
  capital
  previous-capital
  credit-demand
  stock
  labor
  debt
  interest-rate-paying
  rata
  coal?
  failed?
  industrywannabe?
  industry?
  max-labor
  max-labor-industry
  productivity
  industrial-productivity
  price
  labor-price
  installment ;rata da pagare alla banca
  profits
  changed
  condition?
]

farms-own [
  capital
  stock
  labor
  debt
  productivity
  max-production
  price
  labor-price
  previous-capital
  profits
  failed?
  changed
]
;production can be local variable


banks-own [
  deposits
  credit
  credit-demanded
  previous-capital
  capital
  ;taxes ;? see if necessary
  interest-rate
  failed?
  residual-credit
]
government-own [
  incoming-taxes
  account
  ;reserves when making it go put let reserve =budget-taxes
  labor
  wage
  interest-rate
  bonds
  metabolism
  needs
  desires
  wealth
  change
  kids
]

foreign-market-own [
  wealth
  metabolism
  needs
  desires
  goods
  food
  food-price
  goods-price
  last-food
  last-goods

]


;BankofEngland-own []
;it may be smarter in this context to express the bank of England only in the context of inter-banking
;now to assign charachteristics to patches
patches-own [
  grain
]

;;;;;;;;;;;;;;;;;;;;;;;;;;;               Setup Procedures
;;;                     ;;;
;;;  Setup Procedures   ;;;
;;;                     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;for agent substitution you use sprout-breeds n [ commands here ] primitive
;as it produces turtles, or the hatch-breeds n [ command here ] primitive for households
;as it requires a parent turtle?

;set migration as if unemployed for t>1 move either to a random direction or towards a city?
;do this in second iteration when there is household growth
;links may also be used to establish firms

;For food: first households buy from market, then from government.
;Governemnt buys some food at the beginning of each tick to simulate imports

; turtles-here or turtles-at for turtles in the same patch

;put all borghesi in cities, while aristocrats stay in the patch they own

;for agent generation: ask each n ticks to some borghesi to crate a link with up to 6 other
; borghesi in the same tile. If total saving > than a given number they will open a new firm,
;for bank generation have

;aggregates over time must be expressed trough lists, so to store values over time

;export-output to export results

;explore link for employes-workers and firms/banks owners

;explore service markets

;max-n-of and min-n-of for finding lower and highest of somethign
;max-one-of and min for picking only one at a time - probably best for wages and prices
to setup
  clear-all
  ;; set global variables to appropriate values
  clear-globals
  ;set max-grain 100
  ;set  credit-check1 0
  ;set credit-check2 0
  ;set labor-check 0
  ;set labor-check1 0
  ;set labor-check2 0
  ;take all from professor model
  ;; call other procedures to set up various parts of the world
  setup-patches
  setup-bourgeoisie
  setup-workers

  setup-nobility
  setup-farms

  setup-firms
;  setup-banks
  ;setup-BankofEngland
  setup-government
  setup-foreign-market
  ;setup-deposits
  reset-ticks
end

to setup-foreign-market
  set mean-price-farms mean [price] of farms
  set mean-price-firms mean [price] of firms
  set mean-price-services mean [price] of bourgeoisie

  create-foreign-market 1
  ask foreign-market [
    set shape "person"
    set size 0.1
    set color yellow
    set metabolism 0
    set desires 0
    set wealth 0
    set food 0
    set food-price (mean-price-farms + random-float foreign-mark-up)
    set goods 0
    set goods-price (mean-price-firms + random-float foreign-mark-up)

  ]
end

to setup-workers
  create-workers ((number-of-workers / 4) * 3)
  ask workers [
    ;set shape "person"
    set color red
    set wealth 10
    set color red
    set size 0.1
    set shape "person"
    setxy random-xcor random-ycor
    set salary random-normal initial-worker-wage 1
    set kids random-normal (reproduction / 2) (reproduction / 2)
    ;add randomness in later in markets, this is base value
  ]
end

to setup-bourgeoisie
  create-bourgeoisie (number-of-bourgeoisie / 2)
  ask bourgeoisie [
    set color orange
    set wealth random-normal bourgeoisie-initial-capital (bourgeoisie-initial-capital / 5)
    set size 0.1
    set shape "person"
    setxy random-xcor random-ycor
    ; set metabolism random-normal 12 2
    ;  set desires random-normal 5 2
    set price random-normal initial-service-price 5
    set kids random-normal (reproduction / 2) (reproduction / 2)
    set owner? false
  ]
end

to setup-nobility
  ;  to do put wayyyyy more nobles so that they don't actually get so rich, and higher food productivity too?
  ;  orr more farms that share the grain in a patch, each for a noble
  create-nobility (number-of-nobles)
  ask nobility [
    setxy random-xcor random-ycor
    right random 360
    forward random-float 0.05
    set wealth random-normal Nobility-Initial-Capital ( Nobility-Initial-Capital / 5)
    set size 0.1
    set shape "person"
    set color blue
  ]
end

to setup-farms
  ask farms [
    set capital random-normal max-wealth-farm (max-wealth-farm / 5)
    set shape "house"
    set color violet
    set size 0.2
    set productivity max (list 0.1 (random-normal farm-productivity (farm-productivity / 5))) ;historically accurate
    set labor-price random-normal initial-farm-labor-price 1
    set price ((initial-farm-labor-price / productivity) + random-normal farms-margin (farms-margin / 5))
    ;    let people turtles with [shape = "person"]
    ;;; We know that calories were sufficient before the industrial revolution and that farms had productivity of three
    ;;; the following is a way to represent that
    ;    let number-of-people (count people / 3)
    ;    let number-of-farms count farms
    ;    set grain (number-of-people / number-of-farms + random 5)
    ;this is to simulate the historical fact that land was at full use
    let owner min-one-of nobility [distance myself  ]
    ask owner [create-own-with myself]
    set profits 0
    ;create-own-with myself
    ;;metti condizione die per nobily se non hanno azienda agricola
    ;;this should set the max hiring
    let farms-number count farms-here
    let grain-patch [grain] of patch-here
    set max-production (round (grain-patch / farms-number))
  ]

end

to setup-firms
  let industry-owners n-of number-of-firms bourgeoisie
  ask industry-owners [
    set owner? true
    hatch-firms 1 [
      right random 360
      forward random-float 0.5
      set capital random-normal max-wealth-firms (max-wealth-firms / 5)
      set shape "house"
      set color orange
      set size 0.2
      ;let possible-owner bourgeoisie in-radius 1
      ;ask possible-owner in-radius 1 [create-own-with myself]
      ;create-own-with one-of bourgeoisie in-radius 1
      create-own-with myself
      let close in-radius distance-setup patches
      if any? close with [pcolor = black][set coal? true]
      ;see if you want
      set industrywannabe? false
      set max-labor round (random-normal max-labor-firms (max-labor-firms / 5))
      set max-labor-industry round (random-normal max-labor-industrial-firms (max-labor-industrial-firms / 5))
      set stock (productivity + 1)
      set productivity random-normal firm-productivity (firm-productivity / 5)
      set industrial-productivity random-normal firm-industrial-productivity (firm-industrial-productivity / 5)
      set labor-price random-normal initial-firm-labor-price 1
      set price ((initial-firm-labor-price / productivity) +  random-normal firms-margin (firms-margin / 5))
      set failed? false
      set profits 0
      set condition? false
      set industry? false
    ]
  ]
end



to setup-patches
  let number-of-people (number-of-workers + number-of-bourgeoisie + number-of-nobles)
  ask patches [set pcolor green]
  let possible-cities patches
  ask n-of number-of-cities possible-cities[
    set pcolor yellow
    ask neighbors [
      set possible-cities possible-cities with [self != myself]
    ]
    set possible-cities possible-cities with [self != myself]
  ]
  ask n-of number-of-coal possible-cities [
    set pcolor black]
  let pastures count patches with [pcolor = green]
  ask patches [
   if pcolor = green [
      let people-per-patch ((number-of-people / farm-productivity) /  pastures )
      set grain random-normal (people-per-patch) (people-per-patch / 5)
     ; sprout-nobility 1
      sprout-farms 1
    ]
    if pcolor = yellow  [
      ;  sprout-firms number-of-firms
;      sprout-banks number-of-banks
      let number-bourgeoisie ( ( number-of-bourgeoisie / 2) / number-of-cities)
      let number-workers ( ( number-of-workers / 4) / number-of-cities)
      sprout-bourgeoisie number-bourgeoisie [
        set color orange
        set wealth random-normal bourgeoisie-initial-capital (bourgeoisie-initial-capital / 5)
        set size 0.1
        set shape "person"
        right random 360
        forward random-float 1
    ; set metabolism random-normal 12 2
    ;  set desires random-normal 5 2
        set price random-normal initial-service-price (initial-service-price / 5)
        set kids random-normal (reproduction / 2) (reproduction / 2)
  ]
      sprout-workers number-workers [
    ;set shape "person"
    set color red
    set wealth random-float 10
    set color red
    set size 0.1
    set shape "person"
    set salary random-normal initial-worker-wage (initial-worker-wage / 5)
    set kids random-normal (reproduction / 2) (reproduction / 2)
    forward random-float 1
    ;add randomness in later in markets, this is base value
  ]
     ; sprout-workers 2000 [
     ;   right random 360
     ;   forward random-float 1
     ; ]
    ]
  ]
end
;try to add no neighboring patches with [not any? patches with [pcolor = self]]

to setup-government
  create-government 1
  ask government [
    set account random-normal government-budget (government-budget / 5)
    set size 0.1
    set color black
    set interest-rate random-normal 0.06 0.01
    set shape "person"
    set wage government-labor-price
  ]
end


;;;;;;;;;;;;;;;;;;;;;;;;;;;             Go Procedures
;;;                     ;;;
;;;  Go Procedures      ;;;
;;;                     ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;here we have all that's happening each turn, all markets and all operations
;each markets need to be one loop each

;breeds-here gives you all the turtles in that breed in the same patch, very usefull for firms and banks

;for grain productivity use random-float max-grain to get a random number smaller than max productivity
;WHY ARE FIRM CAPITAL EXPLODING

to go
  set taxes 0
  set GDP-income 0
  set GDP-spending 0
  set goods-income-value 0
  set labor-income-value 0
  set land-income-value 0
  set mean-profit-rate 0
  set profit-income-value 0
  set aggregate-employed 0
  set aggregate-unemployment 0
  if ticks > time [
    run-industrial-switching ]
  run-labor-matching
  run-production
  run-demand
  run-food-market
  run-goods-market
  run-foreign-market
  run-service-market
;  run-debt-repaying
  run-dividends
  run-price-adjusting
  run-agent-replacement
  run-government
;  run-deposits-market
 ; stop-simulation
  tick
end
; 'tis better to separate each procedure as bugs are signaled at the algorithm level


to run-industrial-switching
  set industrial-switching-check 0
  set industrial-switching-check2 0
  set industrial-switching-check3 0
        set industrial-switching-check4 0
  ;;     PRODUCTION MODE SWITCHING
  ;remember to cite Roventini's paper as to why the probability
  ;adjust transition costs as lower if there are more firms around with industrial production?
  let coal-industries firms with [(coal?  = true) and (industry? = false) and (industrywannabe? = true)]

  ask coal-industries [
;    let switching-industries firms with [industry? = false]
;    ask switching-industries [
    set industrial-switching-check ( industrial-switching-check + 1)
    let available-capital 0
    let safe-cost 0
    let number random-float 1
    let owner-capital 0

    ifelse safe-zone-switch = "yes" [
    set industrial-switching-check2 (industrial-switching-check2 + 1)
    let close-firms in-radius distance-setup firms
    let industrialized-firms-near close-firms with [industry? = true]
    let count-industry 0
    ifelse any? industrialized-firms-near [
      set count-industry count industrialized-firms-near
    ] [ set count-industry 0.0001]
    let number-industry min (list 5 ( count-industry / 2 ))
    ;this will reduce costs for transitioning but will never reduce them more than half the original
    set safe-cost ((1 + (random-float safe-zone))  * (trans-cost * (1 - (number-industry / 10))))
      ; of gives a list which will result in error "+ expected input to be a number but got the list [number] instead." of one-of solves this
    set owner-capital [wealth] of one-of out-own-neighbors
    set available-capital (capital + owner-capital)
      set industrial-switching-check4 (industrial-switching-check4 + 1)
  ][
    set safe-cost trans-cost
    set available-capital capital
            set industrial-switching-check4 (industrial-switching-check4 + 1)
  ]


;    set safe-cost trans-cost
;    set available-capital capital
    if available-capital >= safe-cost [set condition? true]
;    set condition? true
;;    if capital > safe-cost [set condition? true]
;    if condition? = true [
;    if (condition? = true) and (number <= Industrial-switch-probability) [
    if condition? = true [
;      if number <= Industrial-switch-probability [
      set industrial-switching-check3 (industrial-switching-check3 + 1)
      set industry?  true
      set industrialized-firms (industrialized-firms + 1)
      set industrywannabe? false
      set condition? false
      set max-labor max-labor-industry
      let early-capital capital
      set capital (capital + owner-capital - safe-cost)
      set owner-capital ( owner-capital - (available-capital - early-capital + safe-cost) )
        ask out-own-neighbors [set wealth owner-capital]
      set industrial-switching-check ( industrial-switching-check + 1)
      ]
    if (condition? = true) and (number > Industrial-switch-probability) [
      set condition? false]
    ]
;  ]
  ;; add to probability if neighbours are industrialized raise probability of industrialization
  ;;
end

to run-labor-matching
  ;;     LABOR MARKET SUPPLY
  ;; all workers start unemployed
  ;; I could add a realistic feature, where unemployed people struggle working because they don't eat enough, but that would probably distort the model too much
  ask workers [
    set unemployed? true
    set employed? false
    set state? false
    set firm? false
    set farm? false
  ]
  set unemployed count workers
  set employed 0
  set labor-check 0
 ; let average-salary mean [salary] of workers
  let government-workers round random-normal (number-of-workers / 5) (number-of-workers / 10)
  if government-workers < 0 [set government-workers (number-of-workers / 10)]
  let public-workforce n-of government-workers workers
  let public-salary [wage] of one-of government
  ; of one-of is used to avoid bug where wage is treated not as a value but as a list, resulting in error
  ask public-workforce [
    set wealth (wealth + public-salary)
    set unemployed? false
    set employed? true
    set state? true
    set unemployed (unemployed - 1)
    set employed (employed + 1)
  ]

  ask government [
    let labor-expense (wage * government-workers)
    set labor-income-value (labor-income-value + labor-expense)
    set GDP-income (GDP-income + labor-expense)
    set account (account - labor-expense)
    set labor count workers with [state? = true]
    set aggregate-employed count workers with [employed? = true]
    set labor-check (labor-check + 1)

  ]

  let employers turtles with [shape = "house"]
  ;we create a group by simply setting the same shape ahah I'm so smart
  let min-wage min [salary] of workers
  let unenmployed workers with [unemployed? = true]
  let average-grain mean [grain] of farms
  let seasonality round random-normal 0 (average-grain / 4)
  ; this adds the same impact of a season on all food producers
  ask employers [
    set previous-capital capital
    set labor 0
  ]
  ;this avoids recalculation of previous capital for each hire
  let actual-employers employers with [ capital > labor-price]
  ifelse (any? actual-employers) and (any? unenmployed) [
    ask actual-employers [
      let max-hired 0
      let wages labor-price
      let hirable (capital / wages)
      ;this allows hired to see labor-price
      ;;set hard limit on industry growth
      (ifelse color = violet [
        ;      set condition for max farm productivity equals to grains due to zero max productivity
        set max-hired min list (grain + seasonality) hirable]
        (color = orange) and (industry? = true) [
        set max-hired min list max-labor-industry hirable][
        set max-hired min list max-labor hirable ])
      set unenmployed workers with [unemployed? = true]
      let local-unemployed unenmployed in-radius distance-setup with [salary <= wages]
      if ((count local-unemployed) < 0) or (max-hired < 0) [stop]
      let hired up-to-n-of max-hired local-unemployed
      ;; up-to-n-of is used to avoid bug when there are less local unemployed than what is demanded for
      set labor count hired
      set capital (capital - (labor-price * labor))
      if any? hired [
        ask hired [
          if [color] of myself = orange [set firm? true]
          if [color] of myself = violet [set farm? true]
          set unemployed? false
          set unemployed (unemployed - 1)
          set employed? true
          set employed (employed + 1)
          set aggregate-employed (aggregate-employed + 1)
          set wealth (wealth + wages)
          set labor-income-value (labor-income-value + wages)
          set GDP-income (GDP-income + wages)
        ]
      ]
      set actual-employers employers with [self != myself]
      set labor-check (labor-check + 1)
      stop
    ]
  ] [stop]
  ;now to adjust price
  ask employers [
    let labor-number (previous-capital / labor-price)
    let random-number random-float 1
    if (labor < labor-number) and (random-number > 0.5) [
      set labor-price ( labor-price + (random-normal price-delta (price-delta / 5))) ]
    if (labor = labor-number) and (random-number > 0.5) [set labor-price ( labor-price - (random-normal price-delta (price-delta / 5)))]
  ]

  let unemp workers with [unemployed? = true]
  set aggregate-unemployment count unemp
  let min-salary min [salary] of workers
  let half-min (min-salary / 2)
  ask unemp [
    set unemployment (unemployment + 1)
    set wealth (wealth + half-min)
    set labor-income-value (labor-income-value + half-min)
    set GDP-income (GDP-income + half-min)
    ;assume they find alternative methods of employment

    ;; MIGRATION FOR UNEMPLOYED WORKERS
    ;the longer they are unemployed the more likely it is that they will migrate

    let migrate random-float 1
    let migrate-chance (unemployment * 0.1)
    if (migrate > migrate-chance ) [
      right random 360
      forward 0.5
      ]
      set unenmployed unenmployed with [self != myself]
      ;set migration-check (migration-check + 1)
    ]

  ;;;;

  ask workers [
    let random-number random-float 1
    if (unemployed? = false) and (random-number > 0.5) [
      set salary ( salary + (random-normal price-delta (price-delta / 5))) ]
    if (unemployed? = true) and (random-number > 0.5) [
      set salary ( salary - (random-normal price-delta (price-delta / 5)))]
    if salary < 2 [set salary 2]
  ]
  let employed2 workers with [employed? = true]
  if any? employed2 [
  set mean-salaries (mean [salary] of employed2)
  set mean-salaries-firm-workers (mean [salary] of employed2 with [firm? = true])
  set mean-salaries-farm-workers (mean [salary] of employed2 with [farm? = true])
  set mean-salaries-public-workers (mean [salary] of employed2 with [state? = true])
  ]
end


to run-production


  ;;     PRODUCTIONS OF GOODS AND SERVICES


  ask farms [
    set stock round (labor * (productivity ) + stock)
    set farms-production-check (farms-production-check + 1)
  ]
  set aggregate-farm-production sum [stock] of farms

  ask firms [
    ifelse industry? = true [
      set stock round (labor * industrial-productivity + stock)
      set firms-production-check (firms-production-check + 1)]
    [ set stock round (labor * productivity + stock)
     set firms-production-check (firms-production-check + 1)
    ]
    if industry? = true [
      let number random-float 1
      if number < prod-increase-chance [set industrial-productivity (industrial-productivity + random-normal 0.2 0.1)]]
    ;this is to replicate the fact that innovation was build and improved upon by workers and owners alike
  ]
  set aggregate-industry-production sum [stock] of firms

  ask bourgeoisie [
    ;if they have a firm they should not sell services
    set service max (list (round (service-produced / 2)) (random service-produced))
    set services-production-check (services-production-check + 1)
   if is-own? true  [
      set service 0
    ]
  ]
  set aggregate-services sum [service] of bourgeoisie
  ask foreign-market
  [
    if ticks = 1  [
      set food (aggregate-farm-production / foreign-production-ratio)
      set goods (aggregate-industry-production / foreign-production-ratio)
      set last-food food
      set last-goods goods
    ]
  ]
end

;cerca herding behaviour su abm
; tasso di profitti e/o aperture e fallimenti come criterio per apertura nuove aziende
; probabilità inversamente proporzionale al numero di fallimenti attorno a me per apertura nuova aziende
; anche direttamente industriale
; potremmo chiedere ad un borghese di chiedere grossi prestiti alle banche per aprire un azienda industriale
;ricontrolla crisi di sovrapproduzione


;if capital = 0
;ask turtles in-radius 4  [
 ; set failed (failed + 1)]
;conta % di fallite, se sotto tot. apri azienda, se sopra no perchè non c'è mercato


  ;;    DEMAND SETTING
to run-demand

  set mean-farm-price mean [price] of farms
  set mean-firm-price mean [price] of firms
  set mean-service-price mean [price] of bourgeoisie



;  let consumers turtles with [shape = "person"]

;  ask consumers [
;    set metabolism round (1 + (0.5 * wealth / mean-farm-price) - (0.6 * mean-farm-price ))
;    set needs ( (wealth / mean-firm-price) * (mean-farm-))
;    ;;try to implement cross elasticity
;  ]

  ask workers [
    let spending ( wealth * (max (list 0.7 (random-float demand-workers ))))
    let food-propensity round ((spending / 2)  / mean-farm-price)
    let goods-propensity round ((spending / 5) * 2  / mean-firm-price)
    ; let service-propensity round ((wealth / 6)  / mean-service-price)
    set metabolism max list 1 food-propensity
    set needs goods-propensity
    set demand-check (demand-check + 1)
    set prevmet metabolism
  ;  set desires max list 1 service-propensity
  ]
  ask bourgeoisie [
    let spending ( wealth * (max (list 0.3 (random-float demand-bourgeoisie ))))
    let food-propensity round ((spending / 6) * 2  / mean-farm-price)
    let goods-propensity round ((spending / 6)  * 3 / mean-firm-price)
    let service-propensity round ((spending / 6)  / mean-service-price)
    set metabolism max list 5 food-propensity
    set needs goods-propensity
    set desires service-propensity
    set demand-check (demand-check + 1)
    set prevmet metabolism
  ]

  ask nobility [
    let spending ( wealth * (max (list 0.6 (random-float demand-nobility ))))
    let food-propensity round ((spending / 6)  / mean-farm-price)
    let goods-propensity round ((spending / 6 ) * 2 / mean-firm-price)
    let service-propensity round ((spending / 6) * 3 / mean-service-price)
    set metabolism max list 10 food-propensity
    set needs goods-propensity
    set desires service-propensity
    set demand-check (demand-check + 1)
    set prevmet metabolism
  ]

  ask government [

;  set mean-farm-price mean [price] of farms
;  set mean-firm-price mean [price] of firms
;  set mean-service-price mean [price] of bourgeoisie
    set metabolism ((random-float 0.3 * aggregate-farm-production) / mean-farm-price)
    set needs ((random-float 0.3 * aggregate-industry-production) / mean-firm-price)
    set desires (max (list ((0.4  * aggregate-services) / mean-service-price) ((random-float 0.8 * aggregate-services) / mean-service-price)))

;    let spending (min (list  (  account * 0.  )
;      if spending < 0
;    set metabolism (( spending / 4) / mean-farm-price)
;    set needs (( spending / 4) / mean-firm-price)
;    set desires ((spending / 2) / mean-service-price)
;    set demand-check (demand-check + 1)
  ]

ask foreign-market [
    ; we assume a growing world economy
    set wealth random-normal (foreign-demand + (random (foreign-demand-increse * ticks)))  (foreign-demand / 5)
    set needs (wealth / mean-firm-price)
  ]


  ;remember to add salary constraint on consumptio
  ;; più realistico è propensione al consumo rispetto al guadagno
  ;; fai propensione al consumo, se disoccupato vagamente più alto in linea con il turno precedente se non disoccupato usando salari
  ;set aggregate-metabolism sum [metabolism]
  ;;    MARKET MATCHING
end


;;        FOOD MARKET

to run-food-market
  set exports 0
  set imports 0
  set farms-market-check 0
  let consumers turtles with [ shape = "person"]
  set aggregate-metabolism sum [metabolism] of consumers
  set aggregate-goods-demand sum [needs] of consumers
  let available-food aggregate-farm-production
  ;let still-consumers consumers with [ metabolism > 0]
  let mean-price mean [price] of farms
  let minimum-price min [price] of farms
  let demand consumers with [ (wealth > mean-price) and (metabolism > 0) ]
  let supply farms with [stock > 0]
  ;changed will be needed to calculate profits
  ask farms [set changed 0]
  ;;ifelse sets condition to stop when there is not any more demand or supply
  ifelse (any? demand) and (any? supply) [
    ask demand [
      ;government has black color
      ;in-radius limits the amount of possible firms
      let close-supply supply in-radius distance-setup
      ;; goverment, come back to this?
      ;      if color = black [
      ;        let random-number random 50
      ;        set random-number max list 30 random-number
      ;        let number-firms count supply
      ;        set random-number ( number-firms * (random-number * 0.01))
      ;        set close-supply n-of random-number supply
      ;        set wealth account]
      ;it is possible that there may not be any supply  left, the stop condition will prevent the model from spinning endlessy
      ifelse any? close-supply [
        ;min-one-of gives one of the chosen set of agents with the lower [reporter]
        let low-price min-one-of close-supply [price]
        ;this allows for the price of low-price to be seen by the consumer
        let chosen-price [price] of low-price
        ;this choses the lowest value between the available funds of the consumer and its desire to consume
        let max-buying min list (round (wealth / (chosen-price * tax-rate))) (metabolism )
        ;this allows the consumer to see the stock of the supplier
        let available-stock [stock] of low-price
        ;this choses the lowest value between the desired quantity by the consumer and the available quantity at the seller
        let buying min list max-buying available-stock
        ; if metabolism is satisfied household will reproduce faster
        ifelse buying = metabolism [
          set kids (kids + 1)
          set metabolism 0
          set demand demand with [self != myself]
        ] [set metabolism (metabolism - buying)]
        ;the following lines adjust varius global and local variables
        let spending (buying * (chosen-price * tax-rate))
        set wealth (wealth - spending )
        set land-income-value (land-income-value + spending)
        set GDP-spending (GDP-spending + spending)
        set taxes (taxes + (spending - (chosen-price * buying)))
        ;now for the supply side
        ask low-price [
          set capital (capital + spending)
          set stock (stock - buying)
          set changed (changed + spending)
          ;if stock is depleted seller is removed from supply pool
          if stock = 0 [
            set supply supply with [self != myself]
            set farms-market-check (farms-market-check + 1)
          ]
        ]
        ;if consumer is satisfied or has no more money they are removed from demand
        if (metabolism = 0) or ( wealth < mean-price) [
          set demand demand with [self != myself]
          set farms-market-check (farms-market-check + 1)
          stop
        ]
      ] [stop]
    ]
  ] [stop]
end


;;                     GOODS MARKET


to run-goods-market
  set firms-market-check 0
  let consumers turtles with [ shape = "person"]
  set aggregate-goods-demand sum [needs] of consumers
  let available-goods aggregate-industry-production
  ;let still-consumers consumers with [ needs > 0]
  let mean-price mean [price] of firms
  let minimum-price min [price] of firms
  let demand consumers with [ (wealth > mean-price) and (needs > 0) ]
  let supply firms with [stock > 0]
  ;changed will be needed to calculate profits
  ask firms [set changed 0]
  ifelse (any? demand) and (any? supply) [
    ask demand [
      ;government has black color
      ;in-radius limits the amount of possible firms
      let close-supply supply in-radius distance-setup
      ;; goverment, come back to this?
      ;      if color = black [
      ;        let random-number random 50
      ;        set random-number max list 30 random-number
      ;        let number-firms count supply
      ;        set random-number ( number-firms * (random-number * 0.01))
      ;        set close-supply n-of random-number supply
      ;        set wealth account]
      ;it is possible that there may not be any supply  left, the stop condition will prevent the model from spinning endlessy
      ifelse any? close-supply [
        ;min-one-of gives one of the chosen set of agents with the lower [reporter]
        let low-price min-one-of close-supply [price]
        ;this allows for the price of low-price to be seen by the consumer
        let chosen-price [price] of low-price
        ;this choses the lowest value between the available funds of the consumer and its desire to consume
        let max-buying min list (round (wealth / (chosen-price * tax-rate))) (needs)
        ;this allows the consumer to see the stock of the supplier
        let available-stock [stock] of low-price
        ;this choses the lowest value between the desired quantity by the consumer and the available quantity at the seller
        let buying min list max-buying available-stock
        ; if metabolism is satisfied household will reproduce faster
        ifelse buying = needs [
          set needs 0
          set demand demand with [self != myself]
        ] [set needs (needs - buying)]
        ;the following lines adjust varius global and local variables
        let spending (buying * (chosen-price * tax-rate))
        set wealth (wealth - spending )
        set goods-income-value (goods-income-value + spending)
        set GDP-spending (GDP-spending + spending)
        set taxes (taxes + (spending - (chosen-price * buying)))
        if color = yellow [set exports (exports + (chosen-price * buying))]
        ;now for the supply side
        ask low-price [
          set capital (capital + spending)
          set stock (stock - buying)
          set changed (changed + spending)
          ;if stock is depleted seller is removed from supply pool
          if stock = 0 [
            set supply supply with [self != myself]
            set firms-market-check (firms-market-check + 1)
          ]
        ]
        ;if consumer is satisfied or has no more money they are removed from demand
        if (needs = 0) or ( wealth < mean-price) [
          set demand demand with [self != myself]
          set firms-market-check (firms-market-check + 1)
          stop
        ]
      ] [stop]
    ]
  ] [stop]
end

to run-foreign-market

  let consumers turtles with [ (shape = "person") and (not (color = "yellow")) and (not ( color = "black"))]
  let metabolism-price [food-price] of one-of foreign-market
  let need-price [goods-price] of one-of foreign-market
  let food-buyers consumers with [ (wealth > metabolism-price) and (metabolism > 0)]
  let food-remaining [food] of one-of foreign-market
  ask food-buyers [
    ifelse food-remaining > 0 [
      let buying min (list metabolism ( round (wealth / metabolism-price)))
      set wealth (wealth - ( buying * metabolism-price))
      set exports (imports + ( buying * metabolism-price))
      set food-remaining (food-remaining - buying)
      ask foreign-market [ set food (food - buying)]
    ] [stop]
  ]
  let goods-buyers consumers with [(wealth > need-price) and (needs > 0)]
  let goods-remaining [goods] of one-of foreign-market
  ask goods-buyers [
    ifelse goods-remaining > 0 [
      let buying min (list needs ( round (wealth / need-price)))
      set exports (imports + ( buying * metabolism-price))
      set wealth (wealth - ( buying * need-price))
      set goods-remaining (goods-remaining - buying)
      ask foreign-market [ set goods (goods - buying)]
    ] [stop]
  ]




end
  ;;        SERVICE MARKET


to run-service-market

  let consumers turtles with [ shape = "person"]
  set aggregate-services-demand sum [desires] of consumers
  let available-desires aggregate-services
  ;let still-consumers consumers with [ metabolism > 0]
  let mean-price mean [price] of bourgeoisie
  let minimum-price min [price] of bourgeoisie
  let demand consumers with [ (wealth > mean-price) and (desires > 0) ]
  let supply bourgeoisie with [service > 0]
  ;changed will be needed to calculate profits
;  ask firms [set changed 0]
  ifelse (any? demand) and (any? supply) [
    ask demand [
      ;government has black color
      ;in-radius limits the amount of possible firms
      let close-supply supply in-radius distance-setup
      ;; goverment, come back to this?
      ;      if color = black [
      ;        let random-number random 50
      ;        set random-number max list 30 random-number
      ;        let number-firms count supply
      ;        set random-number ( number-firms * (random-number * 0.01))
      ;        set close-supply n-of random-number supply
      ;        set wealth account]
      ;it is possible that there may not be any supply  left, the stop condition will prevent the model from spinning endlessy
      ifelse any? close-supply [
        ;min-one-of gives one of the chosen set of agents with the lower [reporter]
        let low-price min-one-of close-supply [price]
        ;this allows for the price of low-price to be seen by the consumer
        let chosen-price [price] of low-price
        ;this choses the lowest value between the available funds of the consumer and its desire to consume
        let max-buying min list (round (wealth / (chosen-price * tax-rate))) (desires)
        ;this allows the consumer to see the stock of the supplier
        let available-stock [service] of low-price
        ;this choses the lowest value between the desired quantity by the consumer and the available quantity at the seller
        let buying min list max-buying available-stock
        ; if metabolism is satisfied household will reproduce faster
        ifelse buying = desires [
          set desires 0
          set demand demand with [self != myself]
        ] [set desires (desires - buying)]
        ;the following lines adjust varius global and local variables
        let spending (buying * (chosen-price * tax-rate))
        set wealth (wealth - spending )
        set goods-income-value (service-income-value + spending)
        set GDP-spending (GDP-spending + spending)
        set taxes (taxes + (spending - (chosen-price * buying)))
        ;now for the supply side
        ask low-price [
          set wealth (wealth + spending)
          set service (service - buying)
          ;set changed (changed + spending)
          ;if stock is depleted seller is removed from supply pool
          if service = 0 [
            set supply supply with [self != myself]
            set service-market-check (service-market-check + 1)
          ]
        ]
        ;if consumer is satisfied or has no more money they are removed from demand
        if (desires = 0) or ( wealth < mean-price) [
          set demand demand with [self != myself]
          set service-market-check (service-market-check + 1)
          stop
        ]
      ] [stop]
    ]
  ] [stop]
end

;;        INTEREST AND PROFIT PAYING

to run-dividends
  set aggregate-dividends 0
  set aggregate-profits 0
  let employers turtles with [shape = "house"]

  ask firms [
    if capital < labor-price [
      set failed-firms ( failed-firms + 1)
      ask out-own-neighbors [
        let owned count out-own-neighbors
        if owned < 1 [set owner? false]
      ]
      die
    ]
  ]

  ask farms [
    if capital <= mean-salaries [
      ask out-own-neighbors [
        let transfer min ( list max-wealth-farm ( random ( 0.5 * wealth)))
        set wealth (wealth - transfer)
        ask myself [set capital (capital + transfer)]
      ]
    ]
  ]
  ask employers [
    set profits (capital - previous-capital)
    ;    set profits ((changed * price) - (changed * labor-price))
    let profitable employers with [profits > 0]
    set GDP-income (GDP-income + profits)
    ifelse color = "orange" [
      set goods-income-value (goods-income-value + profits)][
      set land-income-value (land-income-value + profits) ]
    if (any? profitable) and (profits > 0) [
      if profits > 0 [
        let min-dividends (profits / 2)
        let random-dividends (random (profits / 2))
      let dividends (min-dividends + random-dividends)
        ;; this makes it so that most profits for farms go to nobles as it makes no sense for them to invest too heavily in their activity
        set capital (capital - dividends)
        let owners count out-own-neighbors
        ask out-own-neighbors [
          set wealth (wealth + (dividends / owners))
          set profit-income-value (profit-income-value + dividends)
        ]
        set aggregate-profits (aggregate-profits + profits)
        set aggregate-dividends (aggregate-dividends + dividends)
        set dividends-check (dividends-check + 1)
      ]
    ]

    ;      if (capital < mean-salaries) and (failed? = true) and (color = "orange") [
    ;        set failed-firms ( failed-firms + 1)
    ;        die]
    ;      if (capital <= 0) and (color = "orange") [
    ;        set failed? true
    ;      ]

  ]

  ;; hai messo i dividendi due volte, chiamandoli profitti la seconda
  set average-capital-firms mean [capital] of firms
  set average-capital-farms mean [capital] of farms
  ;  set average-capital-banks mean [capital] of banks
end


;;        PRICE ADJUSTING


to run-price-adjusting
  set mean-farm-price-t-1 mean [price] of farms
  ask farms [
    let random-number random-float 1
    if (stock = 0) and (random-number < price-change-chance) and (labor > 0) [
      set price ( price + (random-normal price-delta (price-delta / 5))) ]
    if (stock > 0) and (random-number < price-change-chance) [set price ( price - (random-normal price-delta (price-delta / 5)))]
    if (labor-price / productivity) > price  [ set price ((labor-price / productivity) + 0.5) ]
    set price-adjusting-check (price-adjusting-check + 1)
    if price < 1 [set price 1]
  ]

  ask firms [
    let random-number random-float 1
    if stock <= productivity [set industrywannabe? true]
    if stock > productivity[set industrywannabe? false]
    if (stock <= productivity) and (labor > 0) and (random-number < price-change-chance) [
      set price ( price + (random-normal price-delta (price-delta / 5))) ]
    if (stock > productivity) and (random-number < price-change-chance) [set price ( price - (random-normal price-delta (price-delta / 5)))]
    if (labor-price / productivity) > price  [ set price ((labor-price / productivity) + 0.5) ]
    set price-adjusting-check (price-adjusting-check + 1)
    if price < 1 [set price 1]
  ]

  ask bourgeoisie [
    let random-number random-float 1
    if (service = 0) and (random-number < price-change-chance) [
      set price ( price + (random-normal price-delta (price-delta / 5))) ]
    if (service > 0) and (random-number < price-change-chance) [set price ( price - (random-normal price-delta (price-delta / 5)))]
    set price-adjusting-check (price-adjusting-check + 1)
    if price < 1 [set price 1]
  ]
  set mean-price-farms mean [price] of farms
  set mean-price-firms mean [price] of firms
  set mean-price-services mean [price] of bourgeoisie

  ask foreign-market [
    let random-number1 random-float 1
    let random-number2 random-float 2
    if ( last-food - food = 0) and (random-number1 < price-change-chance )   [set food-price (food-price + random-normal price-delta (price-delta / 5))]
    if ( last-food - food > 0) and (random-number1 < price-change-chance )   [set food-price (food-price - random-normal price-delta (price-delta / 5))]
    if ( last-goods - goods = 0) and (random-number1 < price-change-chance )   [set goods-price (goods-price + random-normal price-delta (price-delta / 5))]
    if ( last-goods - goods > 0) and (random-number1 < price-change-chance )   [set goods-price (goods-price - random-normal price-delta (price-delta / 5))]
  ]

end

;; maybe change from aggregate to local variable, as in local-services service in radius 3
;; see if you want the government to buy stuff too

;; see if you want to rework this, maybe explore if paying > money [set paying money], but you have to
;relate this to the stocks too
;you forgot the government, do that


to run-agent-replacement
  ask workers [
    if kids > reproduction [
      hatch 1 [
        set wealth (wealth / 2)
        set kids 0
      ]
      set wealth (wealth / 2)
      set kids-number (kids-number + 1)
      set kids 0
      set agent-replacement-check (  agent-replacement-check + 1)
    ]
  ]
  ask bourgeoisie [
    if kids > (reproduction + (reproduction / 5)) [
      hatch 1 [
        set wealth (wealth / 2)
        set kids 0
      ]
      set wealth (wealth / 2)
      set kids-number (kids-number + 1)
      set kids 0
      set agent-replacement-check (  agent-replacement-check + 1)
    ]
  ]



  ;;; NEW FIRMS - - - - - - -
  ask n-of replacing bourgeoisie [
    let local-firms firms in-radius 2
 ;   let number-firms count local-firms
;    let actual-wealth (wealth)
    let random-number random-float 1
    if (wealth >= (2 * max-wealth-firms / 3) and ( random-number < opening-chance))  [
      let random-capital (random-normal max-wealth-firms 100)
      let initial-capital min (list random-capital wealth)
      set wealth (wealth - initial-capital)
      set owner? true
      hatch-firms 1 [
        set agent-replacement-check (  agent-replacement-check + 1)
        set capital initial-capital
        set labor 0
        set shape "house"
        set color orange
        set size 0.2
        create-own-with myself
        let close in-radius distance-setup patches
        if any? close with [pcolor = black][set coal? true]
        set industrywannabe? false
        set max-labor round (random-normal max-labor-firms (max-labor-firms / 5))
        set max-labor-industry round (random-normal max-labor-industrial-firms (max-labor-industrial-firms / 5))
        set stock (productivity + 1)
        set productivity random-normal firm-productivity (firm-productivity / 5)
        set industrial-productivity random-normal firm-industrial-productivity (firm-industrial-productivity / 5)
        set labor-price random-normal initial-firm-labor-price 1
        set price ((initial-firm-labor-price / productivity) +  random-normal firms-margin (firms-margin / 5))
        set failed? false
        set profits 0
        set industry? false
      ]
    ]
  ]

  let costs (trans-cost + max-wealth-firms)
  let close in-radius distance-setup patches
  let rich-bougie bourgeoisie with [(wealth > (trans-cost + max-wealth-firms)) and (any? close with [pcolor = black])]
    ask rich-bougie [

  ; %%%%% see agrilove : look at how many industries there are around. The more there are, the more likely it is to open an industry
  ;  %%%%%% the more industrialized they are, the more likely they are to open an already industrialized industry
    let close-firms firms in-radius 2
    let industry-firms count close-firms with [industry? = true]
    set industry-firms max (list close-firms industry-generation-threshold)
    ;this is done this way to avoid the following if to be true before the threshold is actually reached when close-firms = industry-generation-threshold
    let check max (list industrialized-check industry-generation-threshold)
    let number random-float 1
    if (wealth > costs) and (industry-firms > check) and (number < opening-chance) [
      set wealth (wealth - costs)
      set owner? true
;      ask out-dep-neighbors [
;        set capital (capital - deposited) ]
;      set deposited 0
      hatch-firms 1 [
        set agent-replacement-check (  agent-replacement-check + 1)
        set capital (costs - trans-cost)
        set labor 0
        set shape "house"
        set color orange
        set size 0.2
        create-own-with myself
        set industrywannabe? false
        set industry? true
        set max-labor round (random-normal max-labor-firms (max-labor-firms / 5))
        set max-labor-industry round (random-normal max-labor-industrial-firms (max-labor-industrial-firms / 5))
        set stock (productivity + 1)
        set productivity random-normal firm-productivity (firm-productivity / 5)
        set industrial-productivity random-normal firm-industrial-productivity (firm-industrial-productivity / 5)
        set price ((initial-firm-labor-price / productivity) +  random-normal firms-margin (firms-margin / 5))
        set failed? false
        set profits 0
      ]

    ]
    set industrialized-check industry-firms
  ]
  let average-salary-employed (mean [salary] of workers with [ employed? = true])
  let richness (max-wealth-firms * capital-rate-firm-reproduction * (average-salary-employed / initial-worker-wage ))
  ;; maybe introduce this concept more often
  ask firms [
    let rich-firms firms with [capital > richness]
    ifelse any? rich-firms [
      ask rich-firms [
        let number random-float 1
        if number < (opening-chance / 2) [
          let number2 random-float 0.3
          if industry? = false [set capital (capital - (1 - number2))]
          if industry? = true [set capital (capital - (trans-cost - (1 - number2)))]
          hatch 1 [
            set capital (capital / 2)
            right random 360
            forward random-float 1
          ]
          set capital (capital / 2)
        ]
      ]
    ] [stop]
  ]
end


to run-government
  ;;;; buying goods and services? maybe start with food
  ;;; then set up bonds and buyers
  ask government [
    set bonds 0
    set account (account + taxes)
    ;; BOND PAYMENT
    let bond-holders-nobles nobility with [bonds > 0]
    let bond-holders-bourgeoisie bourgeoisie with [bonds > 0]
    let interest-effective (1 + interest-rate)
    let interest-payed (((sum [bonds] of bond-holders-nobles) + (sum [bonds] of bond-holders-bourgeoisie)) *  interest-effective)
    ask bond-holders-nobles [
      set wealth (wealth + (bonds *  interest-effective))]
    ask bond-holders-bourgeoisie [
      set wealth (wealth + (bonds *  interest-effective))]
    set account (account - interest-payed)
    ;; BOND EMISSION
    if account < 0 [
      let value abs account
      set bonds 0
      set bonds round ((value / 100) - 1)
      ;; BOND MARKET
      let households turtles with [shape = "person"]
      ask foreign-market [set households households with [self != myself]]
      ask government [set households households with [self != myself]]
      let rich-households households with [wealth > 100]
      while [(bonds > 0) and (any? rich-households)] [
        ask rich-households [
          set government-check (government-check + 1)
          set bonds (bonds + 1)
          set wealth (wealth - 100)
          ask myself [
            set bonds (bonds - 1)
            set account (account + 100)]
          if wealth < 100 [
            set rich-households rich-households with [self != myself]
          ]
        ]
      ]
    ]
    let random-number random-float 1
    if (bonds = 0) and (random-number > 0.5) [
      set interest-rate ( interest-rate * (1 + (random-normal 0.1 0.05))) ]
    if (bonds > 0) and (random-number > 0.5) [set interest-rate ( interest-rate * (1 - (random-normal 0.1 0.05))) ]
  ]
  set taxes 0
end


;to stop-simulation
;  if ticks > Time [
;;    export-view filename
;;    export-interface filename
;;    export-output filename
;;    export-plot plotname filename
;;    export-all-plots filename
;;    export-world filename
;;    export-all-plots "c:/My Documents/plots.csv"
;    export-all-plots " all-plots-results.csv "
;;    export-world " C:/Users/viso1/Desktop/thesis/results/world-results.csv "
;;    export-world  (word "world-results " date-and-time ".csv")
;    stop
;  ]
;end

;;;;       MISSING

;; GOVERNMENT AS A BUYER OF GOODS AND SERVICES (MAYBE HAVE IT BUY FOOD WHEN YOU IMPLEMENT CASUAL VARIATIONS OF FOOD SUPPLY)
;; TAXATION (( ADD A PERCENTAGE OF THE SALE TO A TAX ACCOUNT AND JUST SEND ALL THE MONEY TO THE GOVERNMENT?))
;; BOND EMISSIONS
@#$#@#$#@
GRAPHICS-WINDOW
1391
10
1894
514
-1
-1
55.0
1
10
1
1
1
0
1
1
1
-4
4
-4
4
1
1
1
ticks
60.0

BUTTON
330
66
385
99
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
288
165
321
number-of-workers
number-of-workers
1000
20000
5000.0
1000
1
NIL
HORIZONTAL

SLIDER
8
320
166
353
number-of-bourgeoisie
number-of-bourgeoisie
100
1000
300.0
100
1
NIL
HORIZONTAL

SLIDER
8
354
166
387
number-of-firms
number-of-firms
0
500
300.0
50
1
NIL
HORIZONTAL

SLIDER
8
392
167
425
number-of-cities
number-of-cities
3
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
7
429
168
462
number-of-coal
number-of-coal
0
5
2.0
1
1
NIL
HORIZONTAL

CHOOSER
187
394
282
439
max-wealth-farm
max-wealth-farm
100 300 500 800 1000 2000 5000 10000
4

CHOOSER
348
448
443
493
max-wealth-firms
max-wealth-firms
100 200 300 400 500 1000 2000 5000 10000
6

CHOOSER
186
337
294
382
government-budget
government-budget
10000 20000 50000 100000 200000 500000
0

CHOOSER
194
500
293
545
trans-cost
trans-cost
1 100 300 500 1000 2000 5000 10000 20000
4

PLOT
2
935
567
1347
average-capital-firms
time
mean-capital
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Firms" 1.0 0 -955883 true "plot average-capital-firms" "plot average-capital-firms"
"Farms" 1.0 0 -11783835 true "plot average-capital-farms" "plot average-capital-farms"

BUTTON
394
66
457
99
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
581
615
1152
925
Aggregate Productions
Time
Values
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Aggregate Food" 1.0 0 -11783835 true "" "plot aggregate-farm-production"
"Aggregate Goods" 1.0 0 -955883 true "" "plot aggregate-industry-production"
"Aggregate Services" 1.0 0 -7171555 true "" "plot aggregate-services"

PLOT
576
932
1153
1343
Prices
Time
Prices
0.0
10.0
0.0
10.0
true
true
"plot mean-price-farms\nplot mean-price-firms\nplot mean-price-services" ""
PENS
"Farm Prices" 1.0 0 -10141563 true "" "plot mean-price-farms"
"Firm Prices" 1.0 0 -955883 true "" "plot mean-price-firms\n"
"Burgeoisie Prices" 1.0 0 -7171555 true "" "plot mean-price-services"
"Average Salary" 1.0 0 -8053223 true "" "plot mean-salaries"

CHOOSER
695
226
792
271
initial-service-price
initial-service-price
5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
11

CHOOSER
386
223
491
268
initial-worker-wage
initial-worker-wage
3 4 4.5 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
8

BUTTON
256
66
319
99
NIL
stop
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
514
281
629
326
prod-increase-chance
prod-increase-chance
0.05 0.1 0.2 0.3 0.4 0.5
4

CHOOSER
191
280
343
325
industry-generation-threshold
industry-generation-threshold
10 11 12 13 14 15
5

MONITOR
592
114
696
159
New Households
count turtles with [shape = \"person\"] - number-of-workers - number-of-bourgeoisie - number-of-nobles - 2
17
1
11

CHOOSER
404
168
545
213
initial-firm-labor-price
initial-firm-labor-price
3 4 5 6 7 8 9 10 11 12 13 14 15
7

CHOOSER
227
167
373
212
initial-farm-labor-price
initial-farm-labor-price
3 4 5 6 7 8 9 10 11 12 13
7

MONITOR
460
63
619
108
Number of Industrialized Firms
count firms with [industry? = true]
0
1
11

CHOOSER
358
282
501
327
Industrial-switch-probability
Industrial-switch-probability
1.0E-4 0.01 0.025 0.05 0.1 0.15 0.2 0.25 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1
2

MONITOR
523
12
680
57
Number of Failed Firms
failed-firms
0
1
11

CHOOSER
239
225
377
270
opening-chance
opening-chance
0.1 0.2 0.3 0.4 0.5
3

MONITOR
666
12
769
57
New Firms
count firms - number-of-firms + failed-firms
17
1
11

PLOT
886
10
1405
322
GDP per Worker
Time
Value
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Average Salary" 1.0 0 -8053223 true "" "plot mean-salaries"
"GDP per worker" 1.0 0 -7500403 true "" "plot (GDP-spending / (count workers with [unemployed? = false]))"
"GDP per capita" 1.0 0 -2674135 true "" "plot (GDP-spending / ((count turtles with [shape = \"person\"]) - 2))"

CHOOSER
180
449
341
494
bourgeoisie-initial-capital
bourgeoisie-initial-capital
100 200 300 400 500 600 700 800 900 1000
4

CHOOSER
301
390
443
435
Nobility-Initial-Capital
Nobility-Initial-Capital
500 1000 2000 3000 4000 5000 6000 7000 8000 9000 1000
7

CHOOSER
10
224
119
269
price-change-chance
price-change-chance
0.1 0.2 0.3 0.4 0.5 0.6
2

CHOOSER
12
168
104
213
replacing
replacing
10 20 30 40 50
2

CHOOSER
110
169
214
214
replacing-industry
replacing-industry
10 20 30 40 50 100 200 500
7

MONITOR
193
10
301
55
Average food price
mean [price] of farms
2
1
11

MONITOR
403
12
513
57
Average good price
mean [price] of firms
2
1
11

MONITOR
124
61
241
106
Average service price
mean [price] of bourgeoisie
2
1
11

MONITOR
8
61
115
106
Average Firm Profit
mean [profits] of firms
2
1
11

MONITOR
10
112
125
157
Average Farm Profits
mean [profits] of farms
2
1
11

MONITOR
9
10
90
55
Unemployed
unemployed
17
1
11

PLOT
4
618
569
928
Average Households
Time
Wealth
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Bourgeoisie" 1.0 0 -7171555 true "" "plot mean [wealth] of bourgeoisie"
"Nobles" 1.0 0 -13345367 true "" "plot mean [wealth] of nobility"
"Workers" 1.0 0 -2674135 true "" "plot mean [wealth] of workers"
"Industry-Owners" 1.0 0 -7500403 true "let industry-owners bourgeoisie with [owner? = true]\nplot mean [wealth] of industry-owners" "let industry-owners bourgeoisie with [owner? = true]\nplot mean [wealth] of industry-owners"

MONITOR
435
113
575
158
Total Service Produced
Aggregate-services
17
1
11

CHOOSER
561
169
699
214
service-produced
service-produced
1 2 3 4 5 6 7 8 9 10
4

MONITOR
135
113
269
158
Total Goods Produced
aggregate-industry-production
17
1
11

MONITOR
289
113
416
158
Total Food Produced
Aggregate-farm-production
17
1
11

SLIDER
7
465
164
498
number-of-nobles
number-of-nobles
10
50
40.0
5
1
NIL
HORIZONTAL

BUTTON
1920
55
2059
88
Industrial Switching
  run-industrial-switching\n 
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1919
95
2060
128
Labor Market Matching
  run-labor-matching\n 
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1920
133
2010
166
Production
  run-production\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1921
170
2040
203
Demand Setting
  run-demand\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1921
209
2045
242
Run food market
  run-food-market\n\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1918
312
2043
345
Dividends paying
run-dividends\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1922
352
2034
385
Price adjusting
run-price-adjusting\n  
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1922
391
2062
424
Agent replacement 
run-agent-replacement
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1931
438
2031
471
Government
run-government
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1925
475
1988
508
NIL
tick
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
0
506
172
539
distance-setup
distance-setup
1
5
2.0
1
1
NIL
HORIZONTAL

CHOOSER
312
337
450
382
tax-rate
tax-rate
1.01 1.015 1.02 1.03 1.04 1.05 1.05
1

PLOT
1160
619
1672
868
Factor Shares of GDP
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"set-plot-y-range 0 1" ""
PENS
"industrial profits share" 1.0 0 -955883 true "" "plot (goods-income-value / GDP-income)\n "
"land profits share" 1.0 0 -13345367 true "" "plot (land-income-value / GDP-income)\n"
"labor income share" 1.0 0 -5298144 true "" "plot (labor-income-value / GDP-income)\n"

MONITOR
623
61
700
106
NIL
labor-check
17
1
11

BUTTON
1936
10
2017
43
start-tick
  set taxes 0\n  set GDP-income 0\n  set GDP-spending 0\n  set goods-income-value 0\n  set labor-income-value 0\n  set land-income-value 0\n  set mean-profit-rate 0\n  set profit-income-value 0\n  ask workers [\n    set unemployed? true\n    set state? false\n    set firm? false\n    set farm? false\n  ]\n  set aggregate-employed 0\n  set aggregate-unemployment 0
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1918
246
2049
279
run-goods-market
  run-goods-market\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1913
281
2047
314
run service market
  run-service-market
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
304
503
442
548
Time
Time
10 100 150 200 250 300 350 400
1

CHOOSER
450
450
548
495
max-labor-firms
max-labor-firms
5 10 15 20
3

CHOOSER
720
455
885
500
max-labor-industrial-firms
max-labor-industrial-firms
40 50 60 100 150
1

CHOOSER
455
390
551
435
firm-productivity
firm-productivity
2 3 4 5 6
1

CHOOSER
564
392
703
437
firm-industrial-productivity
firm-industrial-productivity
5 6 7 8 9 10 11 12
3

MONITOR
110
10
176
55
NIL
employed
17
1
11

CHOOSER
462
338
590
383
government-labor-price
government-labor-price
4 5 6 7 8 9 10
3

CHOOSER
613
335
710
380
foreign-demand
foreign-demand
5000 10000 15000
2

PLOT
932
324
1364
591
GDP
Time
Money
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"GDP Spending" 1.0 0 -16777216 true "" "plot GDP-spending"
"GDP net" 1.0 0 -7500403 true "plot (GDP-spending + exports - imports)" "plot (GDP-spending + exports - imports)"

MONITOR
776
12
883
57
Number of potential industrialized firms
count firms with [ (coal? = true) and (industrywannabe? = true) and (capital > trans-cost)]
17
1
11

MONITOR
712
64
794
109
Gov. Budget
sum [account] of government
2
1
11

MONITOR
710
121
783
166
Avg. Prod.
mean [productivity] of firms
2
1
11

CHOOSER
639
280
731
325
safe-zone
safe-zone
0.1 0.2 0.3 0.4 0.5
1

CHOOSER
552
453
690
498
reproduction
reproduction
150 200 250 300 400 500
0

CHOOSER
130
231
224
276
price-delta
price-delta
0.1 0.2 0.3 0.4 0.5 0.6
3

CHOOSER
739
282
832
327
demand-workers
demand-workers
0.5 0.6 0.7 0.8 0.9 1
4

CHOOSER
730
339
836
384
demand-bourgeoisie
demand-bourgeoisie
0.4 0.5 0.6 0.7 0.8 0.9 1
1

CHOOSER
821
394
922
439
demand-nobility
demand-nobility
0.4 0.5 0.6 0.7 0.8 0.9 1
6

CHOOSER
717
391
814
436
farm-productivity
farm-productivity
3 4 5
2

CHOOSER
707
173
799
218
firms-margin
firms-margin
1 2 3 4 5 6
1

CHOOSER
802
172
894
217
farms-margin
farms-margin
0.5 1 2 3 4 5
2

MONITOR
304
10
402
55
Average Salary
mean [salary] of workers with [ employed? = true]
2
1
11

CHOOSER
449
504
587
549
safe-zone-switch
safe-zone-switch
"yes" "no"
0

CHOOSER
528
227
684
272
foreign-demand-increse
foreign-demand-increse
100 200 300 400 500 1000
4

MONITOR
799
64
877
109
Firms
count firms
17
1
11

MONITOR
599
507
753
552
NIL
industrial-switching-check
17
1
11

MONITOR
763
506
924
551
NIL
industrial-switching-check2
17
1
11

MONITOR
599
554
760
599
NIL
industrial-switching-check3
17
1
11

MONITOR
770
557
931
602
NIL
industrial-switching-check4
17
1
11

MONITOR
800
227
878
272
Failing firms
count firms with [capital < labor-price]
17
1
11

MONITOR
798
118
873
163
total bonds
sum [bonds] of nobility
17
1
11

CHOOSER
192
552
344
597
capital-rate-firm-reproduction
capital-rate-firm-reproduction
1 2 3 4 5 6 7 8
4

CHOOSER
352
552
444
597
foreign-mark-up
foreign-mark-up
1 2 3 4 5 6 7
0

CHOOSER
452
555
587
600
foreign-production-ratio
foreign-production-ratio
1 2 3 4 5 6 7 8 9
4

PLOT
1158
869
1549
1137
Public-Debt
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot ((sum [bonds] of nobility) + (sum [bonds] of bourgeoisie))"

MONITOR
1650
575
1837
620
NIL
count firms with [industry? = 0]
17
1
11

@#$#@#$#@
## TO DO

-fix markets with up-to-n-of

-fix government
-add foreign market
- add lower bound for prices

## WATCH OUT	

- Too many borghesi will 



## WHAT IS IT?

This is a model of the First Industrial Revolution from a macroeconomic perspective. The aim of the model is to reproduce a change in the production functions by firms triggered by high costs of wages relatives to sales, thus testing Allen's industrial revolution hyphotesis

## HOW IT WORKS

Different agents interact in different markets on the demand or supply side

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

The main feature of interest is the percentage of industrialized firms and the wage levels

## THINGS TO TRY

Different initial values can lead to drastically different results. Try chaning initial endowements for agents or prices

## EXTENDING THE MODEL

Interbank system is missing, as it will be added in a later iteration of the model

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

Remember to look at Allen's Techincal change paper 2009

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="First try" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <final>export-world (word "first " random-float 1.0 ".csv")</final>
    <timeLimit steps="250"/>
    <enumeratedValueSet variable="max-labor-industrial-firms">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="opening-chance">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="bourgeoisie-initial-capital">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="replacing">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-labor-price">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Time">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="firm-industrial-productivity">
      <value value="8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foreign-production-ratio">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="government-budget">
      <value value="10000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="firms-margin">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-nobles">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="demand-bourgeoisie">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-firm-labor-price">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-wealth-firms">
      <value value="2000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-coal">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tax-rate">
      <value value="1.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="trans-cost">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-change-chance">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="demand-nobility">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foreign-mark-up">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-bourgeoisie">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-workers">
      <value value="5000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="firm-productivity">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproduction">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="farms-margin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="farm-productivity">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-cities">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="demand-workers">
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="prod-increase-chance">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Nobility-Initial-Capital">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Industrial-switch-probability">
      <value value="0.15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-farm-labor-price">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="safe-zone">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foreign-demand">
      <value value="15000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-worker-wage">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-firms">
      <value value="300"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-wealth-farm">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="service-produced">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-service-price">
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="industry-generation-threshold">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="price-delta">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="capital-rate-firm-reproduction">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-labor-firms">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="foreign-demand-increse">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-setup">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="replacing-industry">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="safe-zone-switch">
      <value value="&quot;yes&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
