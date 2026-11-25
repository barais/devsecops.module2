// ============================================================
// Polycopié — Cours 2 : Gestion de Versions & Git
// Université de Rennes · IRISA / DiverSE
// Olivier Barais
// ============================================================

#set document(
  title: "Cours 2 — Gestion de Versions & Git",
  author: "Olivier Barais",
  date: datetime(year: 2026, month: 9, day: 1),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: luma(130))
      #grid(columns: (1fr, 1fr),
        [DevSecOps — Cours 2 · Université de Rennes],
        align(right)[Olivier Barais]
      )
      #line(length: 100%, stroke: 0.5pt + luma(200))
    ]
  },
  footer: context [
    #set text(size: 8pt, fill: luma(130))
    #line(length: 100%, stroke: 0.5pt + luma(200))
    #v(2pt)
    #grid(columns: (1fr, 1fr),
      [IRISA / DiverSE · 2026],
      align(right)[Page #counter(page).display("1")]
    )
  ]
)

#set text(font: "New Computer Modern", size: 10.5pt, lang: "fr")
#set par(justify: true, leading: 0.65em, spacing: 1.2em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  v(1.5em)
  block(
    fill: rgb("#1e40af"),
    radius: 4pt,
    inset: (x: 10pt, y: 6pt),
    width: 100%,
    text(fill: white, size: 14pt, weight: "bold")[#it.body]
  )
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 12pt, weight: "bold", fill: rgb("#1d4ed8"))[#it.body]
  v(0.3em)
}

#show heading.where(level: 3): it => {
  v(0.5em)
  text(size: 11pt, weight: "bold", fill: rgb("#374151"))[#it.body]
  v(0.2em)
}

// Boîte d'alerte
#let alert(color: red, icon: "⚠", body) = block(
  fill: color.lighten(90%),
  stroke: 0.8pt + color,
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #text(weight: "bold")[#icon  ] #body
]

// Boîte d'exemple
#let example(title, body) = block(
  fill: rgb("#f0f9ff"),
  stroke: (left: 3pt + rgb("#0ea5e9")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0369a1"))[Exemple — #title] \
  #v(4pt)
  #body
]

// Boîte de définition
#let definition(term, body) = block(
  fill: rgb("#f5f3ff"),
  stroke: (left: 3pt + rgb("#7c3aed")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#6d28d9"))[Définition — #term] \
  #v(4pt)
  #body
]

// Boîte de retenir
#let keypoint(body) = block(
  fill: rgb("#fff7ed"),
  stroke: (left: 3pt + rgb("#ea580c")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#c2410c"))[À retenir] \
  #v(4pt)
  #body
]

// Style des blocs de code (remplace cmdbox)
#show raw.where(block: true): it => block(
  fill: rgb("#0f172a"),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[#text(fill: rgb("#94a3b8"), size: 9pt, font: "New Computer Modern")[#it]]

// ============================================================
// PAGE DE TITRE
// ============================================================

#align(center)[
  #v(2cm)
  #block(
    fill: rgb("#1e3a8a"),
    radius: 8pt,
    inset: 20pt,
    width: 90%,
  )[
    #text(fill: white, size: 11pt)[DevSecOps — Université de Rennes · IRISA / DiverSE]
    #v(8pt)
    #text(fill: white, size: 20pt, weight: "bold")[Cours 2]
    #v(4pt)
    #text(fill: rgb("#93c5fd"), size: 15pt)[Gestion de Versions & Git]
    #v(4pt)
    #text(fill: rgb("#bfdbfe"), size: 11pt)[De Subversion à GitFlow]
  ]

  #v(1.5cm)

  #text(size: 11pt, weight: "bold")[Olivier Barais]
  #linebreak()
  #text(size: 10pt, fill: luma(80))[Professeur des Universités · Université de Rennes]
  #linebreak()
  #text(size: 10pt, fill: luma(80))[IRISA UMR 6074 · Équipe DiverSE · INRIA]

  #v(1cm)
  #text(size: 9pt, fill: luma(100))[Année universitaire 2026–2027]

  #v(2cm)
]

#outline(
  title: "Table des matières",
  indent: 1em,
  depth: 2,
)

#pagebreak()

// ============================================================
// 1. INTRODUCTION — COLLABORATION À L'ÈRE DE L'IA AGENTIQUE
// ============================================================

= Collaboration logicielle et enjeux contemporains

== La collaboration dans les projets logiciels

Le défi fondamental du génie logiciel est de permettre à plusieurs développeurs de travailler simultanément sur le même code sans interférence destructrice. Ce problème, qui existait déjà dans les années 1970, a pris une dimension nouvelle avec l'émergence de projets open-source impliquant des milliers de contributeurs, puis avec l'arrivée des agents IA capables de produire du code de manière autonome.

La collaboration logicielle se structure autour de trois niveaux complémentaires :

+ *Niveau artefact* — partager et versionner les fichiers sources. C'est le domaine des systèmes de gestion de versions (VCS), apparus dès 1982 avec RCS (Revision Control System).

+ *Niveau social* — coordonner les équipes, les revues de code, les décisions d'architecture. C'est le domaine des forges logicielles comme GitHub et GitLab, qui ont émergé à partir de 2008.

+ *Niveau automatisation* — valider en continu la qualité du code. C'est le domaine de l'intégration continue (CI/CD), généralisée à partir de 2012.

#definition("Forge logicielle")[
  Une forge logicielle est une plateforme qui combine un système de gestion de versions, des outils de collaboration sociale (issues, pull requests, wiki) et une infrastructure d'intégration continue. GitHub, GitLab, Bitbucket et Gitea sont les principales forges utilisées aujourd'hui.
]

== La collaboration à l'ère de l'IA agentique

Les outils de gestion de versions — VCS, forges, workflows de Pull Request — ont été conçus pour des *humains* qui collaborent. Cette hypothèse fondamentale est en train d'être remise en question.

Demain, des agents IA autonomes contribueront du code, ouvriront des Pull Requests, déclencheront des pipelines CI — en parallèle, 24h/24. Cette évolution soulève des questions inédites auxquelles la pratique n'a pas encore apporté de réponse stabilisée :

- Qui *valide* les commits d'un agent ? Comment s'assure-t-on qu'un agent IA n'introduit pas de code malveillant ou vulnérable ?
- Comment *tracer* la paternité humaine versus IA dans l'historique d'un dépôt ?
- Les branches, les PR et les revues de code sont-elles encore le bon paradigme quand les auteurs sont des machines ?
- Quelle *supply chain* quand le code n'est plus écrit par des humains mais généré à partir d'un modèle dont on ne contrôle pas les données d'entraînement ?

#keypoint[
  Ce cours vous donne les fondations pour comprendre ces enjeux et travailler efficacement avec Git aujourd'hui — en anticipant un futur où les pratiques collaboratives devront s'adapter à des contributeurs non-humains.
]

== Pourquoi un(e) RSSI doit maîtriser les VCS ?

La gestion de versions est souvent perçue comme un outil de développeur. Pour un Responsable de la Sécurité des Systèmes d'Information (RSSI), c'est bien plus : c'est un *journal d'audit immuable*, une *source de vérité opérationnelle* et le premier maillon de la supply chain à sécuriser.

=== Traçabilité et audit de conformité

Chaque commit Git est un événement horodaté, identifié par un hash cryptographique, associé à un auteur. L'historique constitue une trace d'audit naturelle répondant aux exigences des référentiels de sécurité (ISO 27001, PCI-DSS, SOC 2). La commande `git log --follow -p config/firewall.yaml` permet de retracer l'intégralité des modifications d'un fichier de configuration sensible, avec leur auteur et leur justification.

=== Infrastructure as Code et dérive de configuration

Toute configuration moderne — règles Terraform, manifestes Kubernetes, playbooks Ansible, règles SIEM — peut et doit être versionnée dans Git. Cette pratique, connue sous le nom d'*Infrastructure as Code* (IaC), offre plusieurs garanties de sécurité : toute dérive de configuration devient détectable par comparaison avec l'état du dépôt, toute restauration est reproductible, et l'historique permet de dater précisément l'introduction d'une mauvaise configuration.

Cette diversification de Git — versionner au-delà du code : infrastructure, configurations, politiques (sécurité, réseau, observabilité) — est l'idée du *GitOps* : le dépôt devient la *source de vérité unique* de l'état *désiré* du système, et des pipelines appliquent automatiquement cet état, de façon auditable et reproductible.

=== Réponse aux incidents de sécurité

Lorsqu'une CVE est publiée ou qu'une backdoor est découverte, le VCS permet de répondre en minutes :
- `git log -S "eval("` — rechercher du code suspect dans tout l'historique
- `git log --since="2024-01-01" --until="2024-06-01"` — identifier la fenêtre de compromission
- `git revert` — annuler proprement un commit problématique sans réécrire l'historique
- `git diff v1.0..v1.1` — comparer deux releases pour identifier ce qui a changé

=== Détection des secrets et politiques de sécurité

Les VCS permettent de mettre en place des mécanismes préventifs contre la fuite de secrets (mots de passe, clés API, certificats) commités par erreur. Des outils comme `git-secrets`, `truffleHog` et `Gitleaks` s'intègrent dans les hooks de pre-commit pour intercepter ces incidents avant qu'ils ne soient publiés.

=== Intégrité de la supply chain

Les commits et tags signés cryptographiquement (GPG ou Sigstore) permettent de prouver l'identité de l'auteur d'un changement et l'intégrité de ce qui est livré en production. Cette propriété est fondamentale pour les cadres de sécurité de la supply chain comme SLSA (Supply-chain Levels for Software Artifacts) et Sigstore.

#pagebreak()

// ============================================================
// 2. MOTIVATIONS — POURQUOI LA GESTION DE VERSIONS ?
// ============================================================

= Motivations : pourquoi la gestion de versions ?

== Le chaos sans gestion de versions

Imaginez Bob qui prépare un rapport et gère ses versions manuellement :

```
rapport.doc
rapport_sauvegarde.doc
rapport_v1.doc   ← envoyé à Anna pour correction
rapport_v2.doc   ← envoyé à Carol pour avis
rapport_v3.doc   ← version "finale"
rapport_FINAL.doc
rapport_FINAL_v2.doc
rapport_VRAIMENT_FINAL.doc
```

Le problème survient quand Bob reçoit les corrections d'Anna (faites sur v1) et de Carol (faites sur v2), alors qu'il a continué à travailler sur v3. Comment intégrer des corrections faites sur des versions antérieures sans en perdre aucune ?

Ce scénario trivial illustre les trois problèmes fondamentaux de la collaboration sans outil de gestion de versions : l'impossibilité de fusionner des modifications concurrentes, l'absence de traçabilité des changements, et la perte de l'historique des décisions.

== Les trois dimensions du SCM

Le *Software Configuration Management* (SCM) a été théorisé par Estublier dans son article fondateur de 2000 @estublier1995. Trois dimensions structurent les enjeux :

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#eff6ff"), stroke: 1pt + rgb("#3b82f6"), radius: 4pt, inset: 10pt)[
    *Révision* ⏱️\
    Évolution dans le temps. Chaque modification crée une nouvelle version identifiée.
  ],
  block(fill: rgb("#f0fdf4"), stroke: 1pt + rgb("#22c55e"), radius: 4pt, inset: 10pt)[
    *Concurrence* 👥\
    Plusieurs développeurs modifient le même fichier en parallèle.
  ],
  block(fill: rgb("#faf5ff"), stroke: 1pt + rgb("#a855f7"), radius: 4pt, inset: 10pt)[
    *Variantes* 🔀\
    Plusieurs versions d'un même produit (plateformes, clients, features).
  ]
)

#v(0.5em)

Un VCS répond à ces trois dimensions en fournissant : un historique complet de toutes les versions, un mécanisme de gestion des modifications concurrentes (merge), un système de branches pour gérer les variantes, et des outils de collaboration entre développeurs.

#pagebreak()

// ============================================================
// 3. LES SYSTÈMES DE GESTION DE VERSIONS
// ============================================================

= Les systèmes de gestion de versions

== Évolution historique des VCS

Les VCS ont évolué en trois générations, répondant chacune à une limitation de la précédente.

=== Première génération : VCS locaux (RCS, SCCS)

Les premiers systèmes de gestion de versions, comme RCS (Revision Control System, 1982) et SCCS, fonctionnaient uniquement en local. Ils permettaient à un développeur de versionner ses fichiers sur sa propre machine en stockant les diffs successifs. Leur limitation majeure : aucune collaboration possible entre développeurs, aucune sauvegarde distribuée, et un point de défaillance unique (la machine locale).

=== Deuxième génération : VCS centralisés (CVS, Subversion)

CVS (1986) puis Subversion (SVN, 2000) ont introduit le modèle client/serveur. Un serveur central héberge le dépôt faisant autorité. Les développeurs travaillent sur des copies locales (*working copies*) et synchronisent avec le serveur via des opérations *checkout*, *update* et *commit*.

Ce modèle a permis la collaboration à grande échelle, mais présente deux limitations importantes :
- *SPOF (Single Point of Failure)* : si le serveur tombe, plus personne ne peut commiter.
- *Travail hors-ligne impossible* : commit, log, diff nécessitent une connexion au serveur.

=== Troisième génération : VCS distribués (Git, Mercurial)

Git (2005) et Mercurial introduisent le modèle distribué : chaque clone est un dépôt *complet*, avec l'intégralité de l'historique. Les développeurs peuvent commiter, créer des branches, consulter l'historique entièrement en local. La synchronisation avec un serveur distant est une opération explicite (push/pull), non une contrainte.

#keypoint[
  Dans un VCS distribué, il n'y a pas de dépôt "maître" au sens technique — c'est une convention sociale (GitHub = le dépôt de référence) qui en fait le point de synchronisation, pas une contrainte architecturale. Cette propriété offre une résilience totale et élimine le SPOF.
]

== Subversion — Rappels

Subversion reste utilisé dans de nombreuses entreprises, notamment dans les secteurs bancaire et industriel. Ses concepts fondamentaux sont :

- *Révision* : numéro global incrémenté à chaque commit sur le serveur (r1, r2, r3...). Une révision représente l'état du dépôt entier à un instant donné.
- *Trunk* : branche principale, équivalent de `main` dans Git.
- *Branches* : copies du trunk dans le répertoire `branches/`.
- *Tags* : copies du trunk dans le répertoire `tags/`, marquant une version.

```bash
# Checkout initial
svn checkout svn://server/monprojet

# Synchroniser la copie locale
svn update

# Valider les modifications
svn commit -m "Description du changement"

# Créer un tag
svn copy trunk/ tags/v1.0/

# Consulter l'historique
svn log --limit 10
```

#alert(color: rgb("#f59e0b"), icon: "ℹ")[
  SVN est encore le standard dans certains environnements, notamment pour des projets avec des fichiers binaires volumineux. Cependant, *Git est devenu le standard de facto depuis 2010* et représente plus de 90 % des nouveaux projets. Ce cours se concentre sur Git.
]

#pagebreak()

// ============================================================
// 4. GIT — GESTION DE VERSIONS DISTRIBUÉE
// ============================================================

= Git — Gestion de versions distribuée

== Brève histoire de Git

Git est né d'une crise. En 2002, le noyau Linux utilisait BitKeeper, un VCS propriétaire mis à disposition gratuitement par BitMover. En 2005, à la suite d'un différend sur les conditions de licence, BitMover retire l'accès gratuit à la communauté Linux.

Linus Torvalds décide alors de créer son propre VCS en deux semaines. Les objectifs qu'il se fixe sont radicaux : performance pour les grands projets, conception distribuée, protection contre la corruption accidentelle ou malveillante, et support du branching non-linéaire.

Le 5 avril 2005, Linus envoie le premier email annonçant Git. Le 15 juin 2005, Git gère déjà le développement du noyau Linux.

#example("La phrase fondatrice de Linus Torvalds")[
  _"Never mind merging. It's not an SCM, it's a distribution and archival mechanism. I bet you could make a reasonable SCM on top of it, though."_ — Linus Torvalds, 7 avril 2005.

  Cette phrase révèle la philosophie profonde de Git : un mécanisme de distribution de snapshots, et non un outil de gestion de versions au sens classique.
]

GitHub est fondé en 2008 et révolutionne l'adoption de Git en rendant l'hébergement de dépôts public trivial et gratuit. En 2018, Microsoft acquiert GitHub pour 7,5 milliards de dollars. Aujourd'hui, GitHub héberge plus de 100 millions de dépôts publics.

== Avantages et inconvénients de Git

=== Avantages

- *Résilience* : chaque clone est un backup complet. La perte du serveur central n'entraîne aucune perte de données.
- *Vitesse* : les opérations courantes (log, diff, branch, merge) sont locales et quasi-instantanées.
- *Efficacité* : compression cross-repository, déduplication des objets identiques par hachage, transferts minimisés.
- *Branching puissant* : créer une branche est une opération O(1) — Git crée simplement un pointeur sur un commit.
- *Flexibilité de workflow* : Git n'impose aucun workflow. GitFlow, Trunk-Based Development, GitHub Flow — tous sont possibles.
- *Outils avancés* : `git bisect` (dichotomie pour localiser un bug), `git stash` (mise de côté temporaire), `git cherry-pick` (appliquer un commit précis), `git rebase` (réécriture propre de l'historique).

=== Inconvénients

- *Courbe d'apprentissage* : le modèle de Git (index, DAG de commits, refs...) est plus abstrait que SVN.
- *Concept de staging* : l'index (staging area) est déroutant pour les nouveaux utilisateurs.
- *Documentation* : les man pages de Git sont complètes mais peu accessibles aux débutants.

== Architecture interne de Git

=== Le modèle de données : quatre types d'objets

Git stocke toutes les données sous forme d'*objets immuables*, identifiés par leur hash SHA-1 (40 caractères hexadécimaux). Il n'existe que quatre types d'objets :

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#eff6ff"), stroke: 1pt + rgb("#3b82f6"), radius: 4pt, inset: 10pt)[
    *Blob*\
    Contenu brut d'un fichier, sans nom ni métadonnées. Deux fichiers identiques dans deux répertoires différents partagent le même blob.
  ],
  block(fill: rgb("#f0fdf4"), stroke: 1pt + rgb("#22c55e"), radius: 4pt, inset: 10pt)[
    *Tree*\
    Équivalent d'un répertoire. Liste de références vers des blobs et d'autres trees, avec les noms de fichiers et les permissions.
  ],
  block(fill: rgb("#fff7ed"), stroke: 1pt + rgb("#f97316"), radius: 4pt, inset: 10pt)[
    *Commit*\
    Un snapshot de l'arbre de fichiers à un instant donné, plus : référence vers le(s) commit(s) parent(s), auteur, date, et message.
  ],
  block(fill: rgb("#faf5ff"), stroke: 1pt + rgb("#a855f7"), radius: 4pt, inset: 10pt)[
    *Tag*\
    Étiquette symbolique pointant vers un commit, avec métadonnées (tagger, date, message). Utilisé pour les versions de release.
  ]
)

#v(0.5em)

#keypoint[
  Git ne stocke pas des *différences* (diffs) entre versions, mais des *snapshots complets* de l'arbre de fichiers à chaque commit. Les fichiers inchangés ne sont pas dupliqués : Git crée simplement un nouveau pointeur vers le blob existant. Les diffs sont calculés à la volée lors de l'affichage.
]

=== Les trois zones de Git

Comprendre les trois zones est fondamental pour maîtriser Git :

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#eff6ff"), stroke: 1pt + rgb("#3b82f6"), radius: 4pt, inset: 10pt)[
    *Working Directory* 🗂️\
    Les fichiers que vous voyez et éditez au quotidien. Git les trace mais ne les versionne pas automatiquement. `git status` montre leur état.
  ],
  block(fill: rgb("#f0fdf4"), stroke: 1pt + rgb("#22c55e"), radius: 4pt, inset: 10pt)[
    *Index / Stage* 📋\
    La "scène" — sous-ensemble des modifications préparées pour le prochain commit. Permet des commits atomiques et précis. `git add` y dépose les changements.
  ],
  block(fill: rgb("#fff7ed"), stroke: 1pt + rgb("#f97316"), radius: 4pt, inset: 10pt)[
    *Repository (.git)* 📦\
    La base de données Git locale. Contient tous les objets compressés. `git commit` y crée un nouveau commit.
  ]
)

#v(0.5em)

#example("L'index comme outil de précision")[
  Vous modifiez deux fonctions dans le même fichier. La première corrige un bug, la seconde ajoute une fonctionnalité. Grâce à l'index, vous pouvez créer deux commits distincts avec `git add -p` (mode interactif, patch par patch), donnant un historique propre et lisible plutôt qu'un commit fourre-tout "fix bug + add feature".
]

== Commits et historique

=== Anatomie d'un commit

Un commit Git est un objet immuable contenant :
- Un *hash SHA-1* unique (ex: `a1b2c3d4e5f6...`) calculé à partir de son contenu.
- Une référence vers le *tree* représentant le snapshot de l'arbre de fichiers.
- Une ou plusieurs références vers le(s) *commit(s) parent(s)* (zéro pour le commit initial, deux pour un commit de merge).
- Les métadonnées : auteur, committer, dates, et *message de commit*.

Le hash est à la fois l'identifiant unique et un mécanisme d'intégrité : toute modification du contenu d'un commit, aussi minime soit-elle, produit un hash totalement différent.

=== Visualiser l'historique

```
# Historique compact et graphique
git log --oneline --graph

# Exemple de sortie :
* a1b2c3d (HEAD -> main) feat: add auth module
* 7f8e9ab fix: resolve login timeout #142
*   3c4d5e6 Merge branch 'feature/oauth'
|\
| * 1a2b3c4 feat: implement OAuth2 flow
|/
* 5f6g7h8 refactor: extract user service
* 2i3j4k5 Initial commit

# Workflow de base
git add src/auth.ts           # Stage un fichier
git add -p                    # Stage interactif (hunk par hunk)
git commit -m "feat: add JWT authentication"
git log --oneline -10         # Historique compact
git show a1b2c3d              # Détail d'un commit
```

=== Revenir en arrière

Git offre plusieurs mécanismes de retour arrière selon le contexte :

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { rgb("#1e3a8a") } else if calc.rem(row, 2) == 0 { luma(245) } else { white },
    table.header(
      text(fill: white)[*Commande*],
      text(fill: white)[*Effet*],
      text(fill: white)[*Sûreté*],
    ),
    [`git revert <hash>`],   [Crée un nouveau commit annulant les changements. Préserve l'historique.], [✅ Sûr sur branches partagées],
    [`git reset --soft HEAD~1`], [Annule le commit, garde les fichiers staged.], [⚠️ Local seulement],
    [`git reset --mixed HEAD~1`], [Annule le commit, unstage les fichiers.], [⚠️ Local seulement],
    [`git reset --hard HEAD~1`], [Annule le commit ET les modifications du working directory.], [🚨 Irréversible],
    [`git restore <file>`],  [Annule les modifications non staged d'un fichier.], [🚨 Irréversible],
  ),
  caption: [Mécanismes de retour arrière dans Git]
)

#alert(color: rgb("#dc2626"), icon: "⚠")[
  *Règle d'or* : Ne jamais réécrire l'historique d'une branche partagée (`main`, `develop`). Sur du code poussé et partagé, utilisez toujours `git revert` plutôt que `git reset`. Un `git reset` suivi d'un `git push --force` sur une branche partagée peut détruire le travail de vos collègues.
]

#pagebreak()

// ============================================================
// 5. COLLABORATION AVEC GIT
// ============================================================

= Collaboration avec Git

== Cloner, récupérer, envoyer

La collaboration avec Git repose sur quelques opérations de synchronisation entre dépôts locaux et distants :

#definition("origin")[
  Par convention, `origin` désigne le dépôt distant depuis lequel un dépôt local a été cloné. `git clone` crée automatiquement cette référence. On peut ajouter d'autres remotes avec `git remote add <nom> <url>`.
]

- *`git clone <url>`* — Copie complète du dépôt (tous les commits, branches, tags). Crée la référence `origin`.
- *`git fetch`* — Récupère les nouveautés du dépôt distant *sans modifier* le working directory. L'intégration est explicite (via `merge` ou `rebase`).
- *`git pull`* — Raccourci `fetch` + `merge` (ou `fetch` + `rebase` avec `--rebase`). Modifie directement le working directory.
- *`git push`* — Envoie les commits locaux vers le dépôt distant. Refusé si le distant a des commits non intégrés.

```bash
# Cloner un dépôt
git clone https://github.com/org/projet.git

# Récupérer les changements distants (sans modifier le WD)
git fetch origin
git merge origin/main

# Ou en une commande :
git pull origin main

# Envoyer ses commits
git push origin feature/ma-feature

# Voir les commits non poussés
git log origin/main..HEAD

# Voir les commits à récupérer
git log HEAD..origin/main
```

== Merge, Rebase, et Fast-Forward

=== Le merge

La fusion (`merge`) crée un *commit de merge* ayant deux parents : le dernier commit de la branche cible et le dernier commit de la branche source. Elle préserve l'historique exact des deux branches.

=== Le rebase

Le rebase (*rejouer sur une nouvelle base*) réapplique les commits d'une branche, un par un, sur un commit cible. Il produit un historique *linéaire* mais *réécrit* les commits (nouveaux hashes). C'est pourquoi le rebase ne doit jamais être utilisé sur une branche partagée.

=== Le fast-forward

Quand la branche cible n'a pas divergé depuis la création de la branche source (aucun nouveau commit sur la cible), Git peut simplement avancer le pointeur de la branche cible sans créer de commit de merge. C'est un *fast-forward*. Pour forcer la création d'un commit de merge même dans ce cas, on utilise `--no-ff`.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#f0fdf4"), stroke: 1pt + rgb("#16a34a"), radius: 4pt, inset: 10pt)[
    *✅ Merge (`--no-ff`)* : pour les branches de feature intégrées dans `main` ou `develop`. Préserve le contexte et l'historique exact des développements.
  ],
  block(fill: rgb("#faf5ff"), stroke: 1pt + rgb("#9333ea"), radius: 4pt, inset: 10pt)[
    *✅ Rebase* : pour nettoyer sa branche locale avant de proposer une PR. Produit un historique propre et linéaire, plus facile à relire.
  ]
)

#pagebreak()

// ============================================================
// 6. MESSAGES DE COMMIT
// ============================================================

= Messages de commit

== Pourquoi les messages de commit comptent

Un message de commit est de la *documentation* — souvent la seule trace du *pourquoi* d'un changement. Le code montre *quoi* a changé ; le message explique *pourquoi* ce changement était nécessaire. C'est cette information qui sera précieuse six mois plus tard lorsqu'un bug obscur devra être investigué.

#example("Mauvais messages vs bons messages")[
  *Mauvais messages :*
  ```
  7f96f57 polishing
  147709f Tweaks
  22b25e0 fix
  ```

  *Bons messages :*
  ```
  5ba3db6 Fix failing CompositePropertySourceTests
  84564a0 Rework @PropertySource early parsing logic
  e142fd1 Add tests for ImportSelector meta-data
  ```

  Laquelle préféreriez-vous déboguer à 23h un vendredi soir ?
]

== Les quatre règles d'or

Ces règles sont largement adoptées dans la communauté open-source, notamment popularisées par l'article de référence de Chris Beams @beams-commit.

+ *Séparez l'objet du corps* par une ligne vide. La première ligne est le résumé (l'objet) ; les paragraphes suivants développent le contexte.

+ *L'objet doit tenir en 50 caractères maximum*, rédigé à l'impératif présent. Test mnémotechnique : _"If applied, this commit will..."_ → "Fix login timeout bug" ✅, "Fixed the bug" ❌.

+ *Le corps explique le quoi et le pourquoi*, pas le comment. Le code se lit lui-même pour le comment. Le corps apporte le contexte qu'on ne peut pas inférer du diff.

+ *Utilisez les lignes vides* pour structurer le message en paragraphes. Les outils Git (log, format-patch) respectent cette structure.

== Conventional Commits

La spécification *Conventional Commits* @conventional-commits, adoptée notamment par Angular, ajoute une convention de préfixage structuré qui permet d'automatiser la génération de changelogs et la gestion de versions sémantique.

```
<type>(<scope>): <description>
<ligne vide>
[body optionnel]
<ligne vide>
[footer optionnel : références, BREAKING CHANGE]
```

#figure(
  table(
    columns: (auto, auto, 1fr),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { rgb("#374151") } else if calc.rem(row, 2) == 0 { luma(248) } else { white },
    table.header(
      text(fill: white)[*Type*],
      text(fill: white)[*Icône*],
      text(fill: white)[*Usage*],
    ),
    [`feat`],     [✨], [Nouvelle fonctionnalité (SemVer MINOR)],
    [`fix`],      [🐛], [Correction de bug (SemVer PATCH)],
    [`docs`],     [📖], [Documentation uniquement],
    [`style`],    [💎], [Style/formatage, aucun changement fonctionnel],
    [`refactor`], [📦], [Refactoring sans changement de comportement],
    [`test`],     [🚨], [Ajout ou modification de tests],
    [`chore`],    [🎫], [Maintenance (CI, build, dépendances)],
    [`perf`],     [🚀], [Amélioration de performance],
  ),
  caption: [Types de commits — spécification Conventional Commits]
)

#example("Commit complet avec Conventional Commits")[
  ```
  feat(auth): implement OAuth2 login

  Add Google and GitHub OAuth2 providers.
  Closes #145.

  BREAKING CHANGE: The /login endpoint now requires
  a 'provider' parameter.
  ```
  Un `BREAKING CHANGE` dans le footer déclenche automatiquement une incrémentation SemVer MAJOR.
]

#pagebreak()

// ============================================================
// 7. BRANCHES ET GITFLOW
// ============================================================

= Branches et GitFlow

== Les branches Git

Dans Git, une branche est simplement un *pointeur léger vers un commit* — un fichier de 41 octets contenant le hash d'un commit. Créer une branche est une opération O(1), quasi-instantanée, contrairement à SVN où créer une branche implique de copier des fichiers.

```bash
# Créer et basculer sur une branche (syntaxe moderne)
git switch -c feature/auth

# Équivalent classique
git checkout -b feature/auth

# Lister toutes les branches (locales et distantes)
git branch -a

# Fusionner dans main
git switch main
git merge --no-ff feature/auth

# Supprimer la branche (après merge)
git branch -d feature/auth
```

Les branches sont locales par défaut. `git push origin feature/auth` publie une branche sur le dépôt distant.

== GitFlow — Le workflow standard

GitFlow a été introduit par Vincent Driessen en 2010 @driessen-gitflow. Il définit un modèle de branches strict, adapté aux projets avec des cycles de release explicites.

=== Les cinq types de branches

#grid(
  columns: (auto, 1fr),
  gutter: 0.5em,
  stroke: 0.5pt + luma(200),
  inset: 8pt,
  fill: (_, row) => if row == 0 { rgb("#1e3a8a") } else if calc.rem(row, 2) == 0 { luma(248) } else { white },
  text(fill: white, weight: "bold")[Branche], text(fill: white, weight: "bold")[Rôle et règles],
  [`main`], [Code *en production*. Chaque commit correspond à une version livrée. Protégée en écriture directe. Toujours taguée avec un numéro de version.],
  [`develop`], [*Intégration continue* des features. Reflète l'état le plus avancé du développement. Les features y sont fusionnées.],
  [`feature/*`], [*Nouvelles fonctionnalités*. Créées depuis `develop`, fusionnées dans `develop` à la fin. Nommage : `feature/nom-de-la-feature`.],
  [`release/*`], [*Préparation d'une release*. Créée depuis `develop` quand le scope est gelé. Corrections de bugs mineurs uniquement. Fusionnée dans `main` ET `develop`.],
  [`hotfix/*`], [*Corrections urgentes en production*. Créée depuis `main`, fusionnée dans `main` ET `develop`. Incrémente le numéro de patch.],
)

=== Mise en pratique avec git-flow

```bash
# Initialiser GitFlow dans un dépôt existant
git flow init

# Démarrer une feature
git flow feature start user-auth
# → crée feature/user-auth depuis develop

# Terminer la feature (merge + suppression de branche)
git flow feature finish user-auth

# Démarrer une release
git flow release start 2.0.0
git flow release finish 2.0.0
# → merge dans main ET develop, crée tag v2.0.0

# Hotfix urgent en production
git flow hotfix start security-patch
git flow hotfix finish security-patch
# → merge dans main ET develop, nouveau tag
```

=== Avantages et limitations

GitFlow est adapté aux projets avec des cycles de release versionnés (logiciels desktop, bibliothèques, applications mobiles). En revanche, il peut être lourd pour des équipes SaaS pratiquant le déploiement continu, car il multiplie les branches et les opérations de merge.

== Trunk-Based Development

Le *Trunk-Based Development* (TBD) est une alternative à GitFlow, préconisée par les organisations pratiquant le déploiement continu (CI/CD). Son principe est radical : une seule branche principale (`main` ou `trunk`), et des branches de feature éphémères de très courte durée (moins de deux jours idéalement).

Les fonctionnalités en cours de développement sont protégées par des *feature flags* (drapeaux fonctionnels) : le code est déployé mais désactivé, et activé progressivement par configuration.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#f0fdf4"), stroke: 1pt + rgb("#16a34a"), radius: 4pt, inset: 10pt)[
    *GitFlow* 🌳\
    — Adapté aux releases versionnées\
    — Projets mobiles, bibliothèques\
    — Équipes suivant des cycles Agile longs\
    — Supporte les versions parallèles en production
  ],
  block(fill: rgb("#eff6ff"), stroke: 1pt + rgb("#3b82f6"), radius: 4pt, inset: 10pt)[
    *Trunk-Based Development* 🚀\
    — Adapté au SaaS et au déploiement continu\
    — Réduit l'enfer du merge\
    — Idéal avec CI/CD automatisé\
    — Microservices, applications web
  ]
)

#pagebreak()

// ============================================================
// 8. PULL REQUESTS ET REVUE DE CODE
// ============================================================

= Pull Requests et revue de code

== Le workflow Pull Request

La *Pull Request* (PR) — ou *Merge Request* sur GitLab — est le mécanisme central de la collaboration sur les forges modernes. Elle formalise la proposition d'intégrer une branche dans une autre, en créant un espace de discussion, de revue et de validation automatisée.

Le workflow standard d'une PR est le suivant :

+ Le développeur crée une branche de feature et y pousse ses commits.
+ Il ouvre une PR sur la forge, ciblant la branche principale.
+ La forge déclenche automatiquement la pipeline CI/CD (tests, lint, analyse de sécurité).
+ Un ou plusieurs reviewers examinent le code, posent des questions, demandent des modifications.
+ Le développeur intègre les retours en poussant de nouveaux commits sur la branche.
+ Quand les reviewers approuvent et que tous les checks CI passent, la PR est fusionnée.
+ La forge déclenche le déploiement automatique.

== Bonnes pratiques de Pull Request

Une PR efficace doit respecter quelques principes fondamentaux :

- *Petite et focalisée* : une PR = une fonctionnalité ou un bug. Les PRs volumineuses (> 400 lignes) sont moins bien relues et introduisent plus d'erreurs.
- *Description claire* : contexte du changement, ce qui a été modifié, comment tester.
- *Liée à un ticket* : `Closes #142`, `Fixes #67` permettent de fermer automatiquement les issues à la fusion.
- *Tests inclus* : toute nouvelle fonctionnalité ou correction de bug doit être accompagnée de tests.
- *Code propre* : lint passant, pas de code mort, pas de `console.log` oublié.

#example("Template de description de PR")[
  ```markdown
  ## Description
  Implémente l'authentification OAuth2 avec Google.

  ## Changements
  - Ajout du provider Google OAuth2
  - Nouveau endpoint /auth/google/callback
  - Mise à jour de la doc API

  ## Tests
  - [ ] Tests unitaires ajoutés
  - [ ] Tests d'intégration passants
  - [ ] Testé manuellement en staging

  Closes #145
  ```
]

== Signature GPG des commits

La signature cryptographique des commits est un mécanisme de non-répudiation : elle prouve que c'est bien *vous* (ou plutôt, le détenteur de votre clé privée) qui avez réalisé ce commit.

=== Configuration et utilisation

```bash
# Générer une clé GPG
gpg --full-generate-key

# Récupérer l'ID de la clé
gpg --list-secret-keys --keyid-format LONG

# Configurer Git pour utiliser la clé
git config --global user.signingkey <KEY_ID>
git config --global commit.gpgsign true

# Signer manuellement un commit
git commit -S -m "feat: add secure module"

# Vérifier les signatures dans le log
git log --show-signature
```

=== Lien avec la supply chain

La signature des commits est un élément clé de la sécurité de la chaîne d'approvisionnement logicielle. Elle soutient la traçabilité de l'auteur de chaque changement, une attente qui rejoint les exigences du framework SLSA — lequel porte avant tout sur l'intégrité et la provenance des artefacts construits. L'initiative Sigstore propose une alternative moderne à GPG, basée sur OIDC (votre compte GitHub ou Google), qui élimine la complexité de la gestion de clés.

#alert(color: rgb("#0369a1"), icon: "ℹ")[
  Sur GitHub, les commits signés apparaissent avec un badge vert "Verified". Cette fonctionnalité est activée en ajoutant votre clé publique GPG dans vos paramètres (Settings → SSH and GPG keys → New GPG key).
]

#pagebreak()

// ============================================================
// 9. FORGES LOGICIELLES ET OUTILS COMPLÉMENTAIRES
// ============================================================

= Forges logicielles et outils complémentaires

== GitHub — Plus qu'un simple hébergeur Git

GitHub est fondamentalement un *réseau social pour développeurs*, construit autour de Git. Ses fonctionnalités sociales ont transformé la collaboration open-source :

- *Stars* — indicateur de popularité d'un projet.
- *Fork* — copie personnelle d'un dépôt pour contribuer sans droit d'écriture sur l'original.
- *Follow* — suivre l'activité de développeurs.
- *Issues* — suivi de bugs et de demandes de fonctionnalités.
- *Pull Requests* — revue et intégration de code (voir section précédente).
- *Insights* — métriques du projet (contributeurs, commits, fréquence).
- *GitHub Actions* — CI/CD intégré nativement.
- *GitHub Packages* — registry Maven, npm, Docker intégré.

Les principales *alternatives* à GitHub sont :
- *GitLab* : open-source, déployable en self-hosted, avec une pipeline CI/CD particulièrement puissante.
- *Bitbucket* : intégré avec l'écosystème Atlassian (Jira, Confluence).
- *Gitea* : forge légère, idéale pour le self-hosting dans les organisations avec des contraintes de souveraineté.

== Intégration Continue et Déploiement Continu (CI/CD)

L'intégration continue est la pratique qui consiste à déclencher automatiquement une série de vérifications à chaque modification du code : compilation, tests unitaires, tests d'intégration, analyse de qualité, analyse de sécurité.

#example("Workflow GitHub Actions minimal")[
  ```yaml
  # .github/workflows/ci.yml
  name: CI

  on: [push, pull_request]

  jobs:
    test:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - name: Setup Node
          uses: actions/setup-node@v4
          with:
            node-version: '20'
        - run: npm ci
        - run: npm test
        - run: npm run lint
        - name: Security audit
          run: npm audit --audit-level high
  ```
]

Ce workflow se déclenche à chaque push et pull request, installe les dépendances, exécute les tests, vérifie le style du code, et effectue un audit de sécurité des dépendances.

== Outils complémentaires à Git

L'écosystème Git est enrichi par de nombreux outils spécialisés :

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#eff6ff"), stroke: 1pt + rgb("#3b82f6"), radius: 4pt, inset: 10pt)[
    *Gestion de tickets*\
    Jira, GitHub Issues, GitLab Issues — Les mots-clés `Closes #42` dans les commits ou PR ferment automatiquement les tickets correspondants à la fusion.
  ],
  block(fill: rgb("#f0fdf4"), stroke: 1pt + rgb("#22c55e"), radius: 4pt, inset: 10pt)[
    *Outils de build*\
    Maven, Gradle, Make, CMake — Compilation, tests, packaging, gestion des dépendances. L'intégration avec Git permet de déclencher les builds sur les commits.
  ],
  block(fill: rgb("#fff7ed"), stroke: 1pt + rgb("#f97316"), radius: 4pt, inset: 10pt)[
    *Registres de binaires*\
    Maven Central, npm, PyPI, Docker Hub — Les artefacts binaires (JAR, images Docker, paquets npm) ne se versionnent pas dans Git mais dans des registres dédiés.
  ],
  block(fill: rgb("#faf5ff"), stroke: 1pt + rgb("#a855f7"), radius: 4pt, inset: 10pt)[
    *Qualité de code*\
    SonarQube, CodeClimate — Métriques de qualité (dette technique, duplication, complexité cyclomatique), intégrés comme checks dans les PRs.
  ]
)

#pagebreak()

// ============================================================
// 10. BONNES PRATIQUES ET CONCLUSION
// ============================================================

= Bonnes pratiques, limitations et synthèse

== Conseils pratiques

=== Pour les individus

- *Ne pas utiliser de VCS est une faute professionnelle.* Dans tout contexte professionnel ou académique, le code non versionné est une dette technique immédiate.
- *Synchroniser souvent* : des `git pull` fréquents réduisent les conflits de merge.
- *Commits petits et atomiques* : un commit = une modification cohérente. Évitez les commits "WIP" fourre-tout.
- *Messages de commit clairs* : respectez les quatre règles d'or et les Conventional Commits.
- *Toujours tagger les versions distribuées* : `git tag -a v1.0.0 -m "Release 1.0.0"`.
- *Ne jamais travailler directement sur `main`* : toujours passer par une branche.

=== Pour les équipes

- *Définir et documenter un workflow Git* (GitFlow, TBD, GitHub Flow) et le faire respecter via des règles de protection de branches.
- *CI obligatoire sur toutes les branches* : aucun merge sans CI verte.
- *Revue de code systématique via PR* : minimum un approbateur externe à l'auteur.
- *Branches fonctionnelles séparées par domaine* : ne pas mélanger des modifications sans rapport dans une même branche.
- *Versionner également les fichiers de configuration, l'IaC et les scripts de déploiement* : tout ce qui décrit l'état du système doit être dans Git.
- *Éviter les fichiers binaires dans Git* : utiliser Git LFS ou un registre de binaires pour les assets volumineux.

== Limitations des VCS

Git est un outil remarquable mais pas universel. Il présente des limitations importantes dans certains contextes :

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  block(fill: rgb("#fef2f2"), stroke: 1pt + rgb("#ef4444"), radius: 4pt, inset: 10pt)[
    *Fichiers binaires* 📄\
    Git ne sait pas merger intelligemment des fichiers Word, des images ou des PDF. Les gros fichiers binaires gonflent l'historique. Solution : Git LFS (Large File Storage) pour les grands fichiers, registres de binaires pour les artefacts.
  ],
  block(fill: rgb("#fef2f2"), stroke: 1pt + rgb("#ef4444"), radius: 4pt, inset: 10pt)[
    *Diff sémantique* 🔀\
    Git compare les fichiers syntaxiquement, ligne par ligne. Un refactoring de code (renommer une fonction, déplacer un bloc) ne sera pas reconnu comme tel — il apparaîtra comme une suppression et un ajout.
  ],
  block(fill: rgb("#fff7ed"), stroke: 1pt + rgb("#f97316"), radius: 4pt, inset: 10pt)[
    *Données volumineuses* 🗄️\
    Les datasets d'entraînement ML, les assets média → préférer DVC (Data Version Control) ou Git LFS. Un historique avec de gros fichiers binaires devient rapidement ingérable.
  ],
  block(fill: rgb("#fff7ed"), stroke: 1pt + rgb("#f97316"), radius: 4pt, inset: 10pt)[
    *Secrets* 🔐\
    Ne *jamais* commiter des mots de passe, tokens API ou clés privées. L'historique Git est quasi-permanent — un secret commité puis supprimé reste accessible dans l'historique. Outils : git-secrets, truffleHog, Gitleaks.
  ]
)

== Résumé des commandes Git essentielles

#figure(
  table(
    columns: (auto, 1fr),
    stroke: 0.5pt + luma(200),
    fill: (_, row) => if row == 0 { rgb("#374151") } else if calc.rem(row, 2) == 0 { luma(248) } else { white },
    table.header(
      text(fill: white)[*Commande*],
      text(fill: white)[*Description*],
    ),
    [`git init`], [Initialiser un dépôt Git dans le répertoire courant.],
    [`git clone <url>`], [Cloner un dépôt distant (crée la référence `origin`).],
    [`git status`], [Afficher l'état du working directory et de l'index.],
    [`git add <fichier>`], [Ajouter un fichier à l'index (staging area).],
    [`git add -p`], [Ajouter interactivement, hunk par hunk.],
    [`git commit -m "msg"`], [Créer un commit avec le message donné.],
    [`git log --oneline --graph`], [Afficher l'historique compact avec le graphe de branches.],
    [`git diff HEAD~1`], [Différence entre le commit courant et son parent.],
    [`git blame <fichier>`], [Annoter chaque ligne avec l'auteur et le commit qui l'a introduite.],
    [`git switch -c <branche>`], [Créer et basculer sur une nouvelle branche.],
    [`git merge <branche>`], [Fusionner une branche dans la branche courante.],
    [`git rebase <base>`], [Rejouer les commits courants sur une nouvelle base.],
    [`git fetch origin`], [Récupérer les modifications distantes sans les intégrer.],
    [`git pull origin main`], [Récupérer et intégrer les modifications distantes.],
    [`git push origin <branche>`], [Pousser les commits locaux vers le dépôt distant.],
    [`git revert <hash>`], [Annuler un commit en créant un commit inverse.],
    [`git stash`], [Mettre de côté les modifications non commitées.],
    [`git bisect start`], [Lancer une recherche dichotomique pour localiser un bug.],
    [`git tag -a v1.0 -m "..."`], [Créer un tag annoté sur le commit courant.],
    [`git commit -S -m "..."`], [Créer un commit signé GPG.],
  ),
  caption: [Résumé des commandes Git essentielles]
)

== Synthèse

Ce cours a posé les fondations de la gestion de versions avec Git et les pratiques de collaboration modernes. Les points essentiels à retenir sont :

=== Git comme standard industriel

Git est devenu le standard de facto de la gestion de versions. Sa compréhension en profondeur — les trois zones, le modèle d'objets, les mécanismes de synchronisation — est un prérequis pour tout développeur ou professionnel de la sécurité informatique.

=== Les branches et workflows comme outil de qualité

Le branching dans Git est quasiment gratuit. Les workflows comme GitFlow et Trunk-Based Development ne sont pas des contraintes bureaucratiques mais des outils pour maintenir un historique lisible, isoler les développements en cours, et garantir que `main` est toujours en état déployable.

=== Les messages de commit comme documentation

Un historique Git bien rédigé est une documentation de première qualité. Les Conventional Commits permettent en plus d'automatiser la génération de changelogs et la gestion de versions sémantique.

=== La supply chain commence dans Git

Pour un RSSI, le dépôt Git est le premier maillon de la chaîne d'approvisionnement logicielle. Commits signés, branches protégées, CI obligatoire, audit des secrets — toutes ces pratiques constituent la première ligne de défense de la sécurité logicielle.

#keypoint[
  *Git n'est pas qu'un outil de sauvegarde.* C'est un système de collaboration, un journal d'audit, un mécanisme de traçabilité, et la fondation sur laquelle reposent tous les workflows DevSecOps modernes. Maîtriser Git, c'est maîtriser l'infrastructure de confiance du développement logiciel.
]

#pagebreak()

// ============================================================
// BIBLIOGRAPHIE ET RESSOURCES
// ============================================================

= Références et ressources

== Ouvrages fondamentaux

- @chacon2014 — _Pro Git_ (2ème édition, 2014, Apress). Disponible gratuitement en français sur #link("https://git-scm.com/book/fr/v2"). La référence complète sur Git, de l'utilisation quotidienne aux mécanismes internes.

- @humble2010 — _Continuous Delivery_ (2010, Addison-Wesley). Pose les fondements des pratiques de livraison continue sur lesquelles les workflows Git modernes s'appuient.

- @kim2016devops — _The DevOps Handbook_ (2016, IT Revolution Press). Contextualise la gestion de versions dans le cadre plus large des pratiques DevOps.

== Ressources d'apprentissage interactif

- *Learn Git Branching* — #link("https://learngitbranching.js.org/?locale=fr_FR"). Visualisation interactive des opérations Git. Fortement recommandé pour comprendre le modèle de branches.

- *GitHub Flow* — #link("https://docs.github.com/fr/get-started/using-github/github-flow"). Documentation officielle GitHub Flow.

- *Trunk Based Development* — #link("https://trunkbaseddevelopment.com/"). Référence complète sur le TBD.

== Ressources sécurité et supply chain

- *Sigstore / gitsign* — #link("https://docs.sigstore.dev/"). Alternative moderne à GPG pour la signature des commits.

- *SLSA Framework* — #link("https://slsa.dev/"). Cadre de niveaux de sécurité pour les artefacts logiciels.

- *pre-commit* — #link("https://pre-commit.com/"). Framework de hooks de pre-commit pour automatiser les vérifications.

- *Gitleaks* — #link("https://github.com/gitleaks/gitleaks"). Détection de secrets dans les dépôts Git.

== Outils recommandés

- *VS Code + GitLens* — Extension VS Code pour une visualisation riche de l'historique Git directement dans l'éditeur.
- *GitHub Desktop* — Interface graphique simple et efficace pour les débutants.
- *GitKraken* — GUI visuel avancé avec visualisation du graphe de commits.
- *Magit* — Interface Git pour Emacs, considérée par beaucoup comme la meilleure interface Git existante.

#bibliography("refs.bib", title: none, style: "ieee")
