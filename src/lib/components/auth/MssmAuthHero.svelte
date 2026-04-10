<!--
	OPEN-WEBUI-MSSM: Mount Sinai branded /auth hero. Merge upstream: touch this file, not auth/+page.svelte.
-->
<script lang="ts">
	import { base } from '$app/paths';
	import DOMPurify from 'dompurify';
	import { marked } from 'marked';
	import { getContext } from 'svelte';

	import type { MssmSsoProvider } from '$lib/mssm/auth-hero';
	import { MSSM_BRAND } from '$lib/mssm/auth-hero';

	const i18n = getContext('i18n');

	export let ssoProvider: MssmSsoProvider | null = null;
	export let showClassicSignInLink = false;
	export let loginFooter: string | undefined = undefined;
	export let openClassicSignIn: () => void;
</script>

<svelte:head>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
	<link
		href="https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600;700;800&display=swap"
		rel="stylesheet"
	/>
</svelte:head>

<div class="auth-alt-shell">
	<section class="auth-alt-card">
		<div
			class="auth-alt-card__media"
			style={`background-image: linear-gradient(90deg, rgba(18, 32, 104, 0.18) 0%, rgba(18, 32, 104, 0.08) 28%, rgba(18, 32, 104, 0.02) 48%, rgba(18, 32, 104, 0.4) 100%), url('${MSSM_BRAND.panel}')`}
			aria-hidden="true"
		></div>
		<div class="auth-alt-card__content">
			<!-- Invisible block: same size as former top logo so copy stays vertically aligned -->
			<div class="auth-alt-logo-spacer" aria-hidden="true"></div>
			<div class="auth-alt-copy">
				<p class="auth-alt-kicker">INTRODUCING AIR·MS</p>
				<h1 class="auth-alt-title">
					AI <span>Agent</span>
				</h1>
				<p class="auth-alt-description">
					The AIR·MS AI Agent is a large language model running on Minerva, Mount Sinai's supercomputer. We're in the
					process of adding functionality, so check back soon!
				</p>
				<button
					class="auth-alt-cta"
					class:auth-alt-cta--disabled={!ssoProvider}
					type="button"
					disabled={!ssoProvider}
					on:click={() => ssoProvider && (window.location.href = ssoProvider.url)}
					aria-label={$i18n.t('Start')}
				>
					{$i18n.t('Start')}
				</button>
				{#if !ssoProvider && !showClassicSignInLink}
					<p class="auth-alt-provider auth-alt-provider--muted">
						SSO is not configured for this server.
					</p>
				{/if}
				{#if showClassicSignInLink}
					<button type="button" class="auth-alt-classic-link" on:click={openClassicSignIn}>
						{$i18n.t('Continue with Email')}
					</button>
				{/if}
			</div>

			<div
				class="auth-alt-partner-logos mt-10 pt-8 w-full border-t border-gray-700/10 dark:border-gray-100/10 flex justify-center"
			>
				<div
					class="auth-alt-partner-logos__row flex items-center justify-center gap-5 sm:gap-7 md:gap-8 shrink-0"
				>
					<div class="auth-alt-partner-slot auth-alt-partner-slot--mssm">
						<img
							src={`${base}/static/branding/login/logo-mount-sinai-dark.svg`}
							class="h-full w-full object-contain object-center block"
							alt="Icahn School of Medicine at Mount Sinai"
						/>
					</div>
					<div class="auth-alt-partner-rule" aria-hidden="true"></div>
					<div class="auth-alt-partner-slot auth-alt-partner-slot--hpims">
						<img
							src={`${base}/static/branding/login/logo-hpims-dark.svg`}
							class="h-full w-full object-contain object-center block"
							alt="HPI·MS"
						/>
					</div>
					<div class="auth-alt-partner-rule" aria-hidden="true"></div>
					<div class="auth-alt-partner-slot auth-alt-partner-slot--d4l">
						<img
							src={`${base}/static/branding/login/logo-data4life-dark.svg`}
							class="h-full w-full object-contain object-center block"
							alt="data4life"
						/>
					</div>
					<div class="auth-alt-partner-rule" aria-hidden="true"></div>
					<div class="auth-alt-partner-slot auth-alt-partner-slot--hpi">
						<img
							src={`${base}/static/branding/login/logo-hpi-dark.svg`}
							class="h-full w-full object-contain object-center block"
							alt="Hasso Plattner Institut"
						/>
					</div>
				</div>
			</div>
		</div>
	</section>

	{#if loginFooter}
		<div class="auth-alt-footer marked">
			{@html DOMPurify.sanitize(marked(loginFooter))}
		</div>
	{/if}
</div>

<style>
	:global(#auth-page) {
		overflow: hidden;
	}

	.auth-alt-shell {
		position: relative;
		z-index: 0;
		width: 100%;
		box-sizing: border-box;
		padding: clamp(0.5rem, 2vmin, 1.25rem);
		min-height: 100vh;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 0.75rem;
		font-family: 'Poppins', sans-serif;
	}

	.auth-alt-shell::before {
		content: '';
		position: fixed;
		inset: 0;
		z-index: -1;
		--s: 35px;
		--c1: #98c8e4;
		--c2: #a6cae3;
		--c: #0000, var(--c1) 0.5deg 119.5deg, #0000 120deg;
		--g1: conic-gradient(from 60deg at 56.25% calc(425% / 6), var(--c));
		--g2: conic-gradient(from 180deg at 43.75% calc(425% / 6), var(--c));
		--g3: conic-gradient(from -60deg at 50% calc(175% / 12), var(--c));
		background-image: var(--g1), var(--g1), var(--g2), var(--g2), var(--g3), var(--g3);
		background-position:
			0 0,
			var(--s) calc(1.73 * var(--s)),
			0 0,
			var(--s) calc(1.73 * var(--s)),
			var(--s) 0,
			0 calc(1.73 * var(--s));
		background-size: calc(2 * var(--s)) calc(3.46 * var(--s));
		background-color: var(--c2);
	}

	.auth-alt-card {
		position: relative;
		box-sizing: border-box;
		width: min(60vw, calc(100vw - 2rem));
		height: min(80vh, calc(100dvh - 2rem));
		max-width: 56rem;
		max-height: 44rem;
		min-height: 18rem;
		border-radius: clamp(12px, 3vw, 28px);
		overflow: hidden;
		box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
	}

	.auth-alt-card__media {
		position: absolute;
		inset: 0;
		background-position: center;
		background-repeat: no-repeat;
		background-size: cover;
		transform: scale(1.01);
	}

	.auth-alt-card__content {
		position: relative;
		box-sizing: border-box;
		height: 100%;
		min-height: 0;
		padding: 5%;
		display: flex;
		flex-direction: column;
		justify-content: flex-start;
		align-items: flex-start;
	}

	/* Matches former `.auth-alt-logo` footprint (Icahn SVG viewBox 127×52) */
	.auth-alt-logo-spacer {
		min-height: 15%;
		flex-shrink: 0;
	}

	.auth-alt-copy {
		width: min(37%, 20rem);
		max-width: 100%;
		flex: 0 1 auto;
		margin-top: clamp(0.75rem, 4vh, 2rem);
		display: flex;
		flex-direction: column;
		align-items: flex-start;
		text-align: left;
		color: #fff;
	}

	.auth-alt-partner-logos {
		flex-shrink: 0;
		align-self: stretch;
		margin-top: auto;
	}

	.auth-alt-partner-logos__row {
		max-width: 100%;
	}

	.auth-alt-partner-rule {
		align-self: stretch;
		width: 1px;
		min-height: 2.5rem;
		background: rgba(255, 255, 255, 0.12);
		flex-shrink: 0;
	}

	.auth-alt-partner-slot {
		display: flex;
		align-items: center;
		justify-content: center;
		height: 2.5rem;
		flex-shrink: 0;
	}

	@media (min-width: 640px) {
		.auth-alt-partner-slot {
			height: 2.75rem;
		}

		.auth-alt-partner-rule {
			min-height: 3rem;
		}
	}

	.auth-alt-partner-slot--mssm {
		width: clamp(6.5rem, 18vw, 9.5rem);
	}

	.auth-alt-partner-slot--hpims {
		width: clamp(2.25rem, 6vw, 3.25rem);
	}

	.auth-alt-partner-slot--d4l {
		width: clamp(3.75rem, 10vw, 5.25rem);
	}

	.auth-alt-partner-slot--hpi {
		width: clamp(4.5rem, 12vw, 7.5rem);
	}

	.auth-alt-kicker {
		margin: 0 0 0.2rem;
		font-size: max(0.5rem, min(3vh, 0.85rem));
		font-weight: 500;
		letter-spacing: 0.24em;
	}

	.auth-alt-title {
		margin: 0;
		font-size: max(1.25rem, min(5vw, 3.25rem));
		font-weight: 500;
		line-height: 1;
	}

	.auth-alt-title span {
		color: rgb(0, 174, 239);
	}

	.auth-alt-description {
		margin: 0.6rem 0 0;
		font-size: max(0.5rem, min(0.85vw, 0.95rem));
		font-weight: 200;
		line-height: 1.65;
		max-width: 100%;
	}

	.auth-alt-cta {
		margin-top: clamp(1rem, 4vh, 2.5rem);
		display: flex;
		align-items: center;
		justify-content: center;
		width: min(15vw, 150px);
		max-width: 100%;
		height: min(4vh, 50px);
		min-height: 2.25rem;
		padding: 0 1rem;
		border: 0;
		border-radius: 999px;
		background: rgb(0, 174, 239);
		color: white;
		font-size: max(0.625rem, min(1vw, 0.875rem));
		font-weight: 600;
		letter-spacing: 0.01em;
		cursor: pointer;
		transition:
			transform 120ms ease,
			box-shadow 120ms ease,
			background-color 120ms ease;
		box-shadow: 0 0 0 rgba(0, 174, 239, 0);
	}

	.auth-alt-cta:hover {
		transform: translateY(-1px);
		box-shadow: 0 6px 18px rgba(0, 174, 239, 0.45);
		background: rgb(0, 184, 249);
	}

	.auth-alt-cta:active {
		transform: translateY(0);
		box-shadow: 0 3px 8px rgba(0, 0, 0, 0.35);
	}

	.auth-alt-cta--disabled,
	.auth-alt-cta:disabled {
		opacity: 0.45;
		cursor: not-allowed;
		box-shadow: none;
	}

	.auth-alt-cta--disabled:hover,
	.auth-alt-cta:disabled:hover {
		transform: none;
		box-shadow: none;
		background: rgb(0, 174, 239);
	}

	.auth-alt-classic-link {
		margin-top: 1rem;
		padding: 0;
		border: none;
		background: none;
		color: rgba(255, 255, 255, 0.92);
		font-size: clamp(0.85rem, 1vw, 0.95rem);
		font-weight: 500;
		text-decoration: underline;
		text-underline-offset: 0.2em;
		cursor: pointer;
		align-self: flex-start;
	}

	.auth-alt-classic-link:hover {
		color: #fff;
	}

	.auth-alt-provider {
		margin: 0.9rem 0 0;
		font-size: 0.78rem;
		font-weight: 400;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		color: rgba(255, 255, 255, 0.82);
	}

	.auth-alt-provider--muted {
		text-transform: none;
		letter-spacing: 0.04em;
		color: rgba(255, 255, 255, 0.75);
	}

	.auth-alt-footer {
		max-width: min(60vw, 56rem);
		margin: 0 auto;
		font-size: 0.72rem;
		color: rgba(15, 23, 42, 0.75);
	}

	@media (max-width: 980px) {
		.auth-alt-card {
			width: min(92vw, calc(100vw - 1.5rem));
			height: min(82vh, calc(100dvh - 2rem));
			max-height: none;
		}

		.auth-alt-card__content {
			padding: 6% 5%;
			background: linear-gradient(180deg, rgba(17, 24, 39, 0.1) 0%, rgba(17, 24, 39, 0.45) 100%);
		}

		.auth-alt-copy {
			width: min(88%, 24rem);
		}

		.auth-alt-title {
			font-size: max(1.35rem, min(7vw, 2.75rem));
		}
	}

	@media (max-width: 640px) {
		.auth-alt-shell {
			padding: 0.5rem;
		}

		.auth-alt-card {
			width: calc(100vw - 1rem);
			height: min(78vh, calc(100dvh - 1rem));
			min-height: 16rem;
		}

		.auth-alt-card__content {
			padding: 1rem 0.9rem;
		}

		.auth-alt-copy {
			width: 100%;
		}

		.auth-alt-cta {
			width: min(42vw, 150px);
		}

		.auth-alt-kicker {
			letter-spacing: 0.18em;
		}

		.auth-alt-provider {
			letter-spacing: 0.06em;
		}
	}
</style>
