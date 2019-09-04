check PortalTokenAlwaysPresentInIdentityProvider {
  // If at any time any of our customer portals has an
  // identity token for a user, then our Identity Provider
  // must know about that token
  no t: Time |
	some portal: CustomerPortal |
		some portal.tokens.t
		and not portal.tokens.t in Identity.tokens.t
}
