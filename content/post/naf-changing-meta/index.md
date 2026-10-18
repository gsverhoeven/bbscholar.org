---
title: "The meta after one year Third Season: has it stabilized?"
author: "Gertjan Verhoeven"
date: "2026-10-18"
summary: This post is about the impact of Third Season aka BB2025 on NAF ranked Tabletop tournament play. In particular, we focus on whether the meta has stabilized.
slug: "naf-changing-meta"
draft: false
categories:
- Meta, NAF
tags:
- Time series
baseurl: "https:/bbscholar.org"
image: "banner.jpg"
editor: source
---

This post is about the impact of Third Season aka BB2025 on NAF ranked Tabletop tournament play. In particular, we focus on whether the meta has stabilized. First, we compare two points in time: the current meta (september 2026) compared to one year ago. The meta one year ago was pretty stable, as we will see if we look at monthly data over the past few years. Then in November 2025 the proverbial "Season 3" rock was thrown in the pond, and one year later, here we are. Some big meta changes have occured.

Then, we go beyond the "before / after" changes and look at how team popularity has changed over time in the last year. And try to answer the question, did the meta stabilize yet? Or is the meta still in flux, with people learning, changing their behavior, tournament rulesets and tierings adapting?



# The data: NAF tabletop

We look at NAF table top tournaments for the BB2020 and BB2025 variants.

I wrote a script that pulls the nightly NAF data dump, and transforms this into a dataset ready for analysis.



# Rapid shift to new ruleset

So how did the tournament organizers respond to Season 3? Lets plot monthly game volume for both Season 2 and Season 3.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" alt="" width="672" />

In 2025-2026, about 5000 NAF ranked games are played each month. We can see that the transition of tournaments to the new ruleset was quite fast, in roughly two months time (dec '25 - jan '26) all tournaments had switched to the new ruleset. No gradual shift, but BAM, let's all move to Third Season.

# The current meta: what has changed?

September 2026 is the most recent, roughly complete month that we can analyse. As each game has two teams participating, we have about 5000 x 2 = 10000 team picks observations. If all races are roughly equally popular, this translates to about 300 games per team, with a percentage share of 3%. A quick and dirty statistical power analysis shows that this is sufficient sample size to result in relatively stable % share average for each team.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" alt="" width="672" />

Big increases in popularity are seen for High Elves, Human, Dark Elf, Nurgle, and OWA. Big decreases in popularity are seen for Shambling Undead, Dwarf, Vampire and Amazons.

# So ... did it stabilize?

To see whether the meta stabilized, we look how the monthly team shares develop over time since the introduction of Season 3. As a control to what the monthly changes were before Season 3, I include a period of 18 months of Season 2 as well.



Short answer, no. Some of the big swings in the data have clearly not stabilized yet. This is clearly visible for the team plotted below. Among these are big movers such as **Nurgle**, **OWA** and **Humans**, but also less popular teams such as **Elf Union** and **Slann**.

To "guide the eye" , I fitted a weighted robust second order linear fit through the aggregated data, before and after the introduction of Third season in late 2025.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" alt="" width="672" />

# A second rock in the pond: the new High Elf roster

When Season 3 was introduced, the **High Elf** roster was not in the rulebook, but included as separate document "Teams of Legend" . In Season 2, High Elf was not a popular roster at tournaments, and Season 3 did nothing to change that.

Then, the team's popularity exploded after the new roster was released in march 2026, and **High Elfs** are currently (September 2026) the most popular team together with **Orcs**.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" alt="" width="672" />

# Signs of stabilization

A few teams show "shock" effects that have stabilized, some to pre-shock levels, but also at lower or higher levels.

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" alt="" width="672" />

# Shaken, but not stirred

Finally, there are several races that have virtually not changed at all in popularity. Among these, we have **Chaos Dwarf**, **Black Orcs** , **Goblins** **Skaven** and **Lizardmen** .

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" alt="" width="672" />

# In conclusion: Did the dust settle?

Somewhat, but we're not there yet. From the monthly plots, it is clear that some teams are at a steady level, but others are still showing systematic monthly changes, as tournament rulesets adapt, people switch to new teams, people learn about the changes in Season 3 and respond.
