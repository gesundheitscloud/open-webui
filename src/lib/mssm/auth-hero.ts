import { WEBUI_BASE_URL } from '$lib/constants';

/** Query `?layout=mount-sinai` or backend `metadata.auth_layout`; classic via `?layout=classic`. */
export const MSSM_AUTH_LAYOUT = 'mount-sinai';

/** Same-origin `/static/*` (Vite :5173); not `WEBUI_BASE_URL` (:8080 API). */
export const MSSM_BRAND = {
	panel: '/static/branding/login/scd_back.png'
} as const;

const SSO_KEY_ORDER = ['oidc', 'microsoft', 'google', 'github', 'feishu'] as const;

export type MssmSsoProvider = { key: string; label: string; url: string };

export function pickSsoProvider(providers: Record<string, string> = {}): MssmSsoProvider | null {
	const keys = Object.keys(providers);
	if (!keys.length) return null;
	const key = SSO_KEY_ORDER.find((k) => providers[k]) ?? keys[0];
	return {
		key,
		label: providers[key] || key,
		url: `${WEBUI_BASE_URL}/oauth/${key}/login`
	};
}
