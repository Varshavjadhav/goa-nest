import { useCallback, useEffect, useMemo, useState } from 'react';
import {
  Activity, ArrowDownRight, ArrowUpRight, BadgeCheck, BedDouble, Bell, CalendarDays,
  Check, ChevronDown, ChevronLeft, ChevronRight, CircleHelp, ClipboardList, Compass,
  DoorOpen, Ellipsis, Eye, EyeOff, Filter, House, LayoutDashboard, LoaderCircle,
  LogOut, MapPin, Menu, MessageSquare, MoreHorizontal, Plus, RefreshCw, Search,
  Settings2, ShieldCheck, SlidersHorizontal, Star, Tag, Users, X,
} from 'lucide-react';
import { api, apiBaseUrl } from './api';

const nav = [
  { id: 'overview', label: 'Overview', icon: LayoutDashboard, group: 'Workspace' },
  { id: 'properties', label: 'Properties', icon: House, group: 'Workspace' },
  { id: 'bookings', label: 'Bookings', icon: CalendarDays, group: 'Workspace' },
  { id: 'categories', label: 'Categories', icon: Tag, group: 'Manage' },
  { id: 'people', label: 'Guests & hosts', icon: Users, group: 'Manage' },
  { id: 'reviews', label: 'Reviews', icon: MessageSquare, group: 'Manage' },
];

const money = (value) => new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 }).format(value || 0);
const date = (value) => value ? new Date(value).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' }) : '—';
const initials = (value = '') => value.split(/\s+/).slice(0, 2).map((part) => part[0]).join('').toUpperCase() || 'G';

function App() {
  const [token, setToken] = useState(() => sessionStorage.getItem('goanest_admin_token') || '');
  const [user, setUser] = useState(() => {
    try { return JSON.parse(sessionStorage.getItem('goanest_admin_user') || 'null'); } catch { return null; }
  });
  const [page, setPage] = useState('overview');
  const [drawer, setDrawer] = useState(false);
  const [toast, setToast] = useState('');
  const [version, setVersion] = useState(0);
  const [working, setWorking] = useState(false);
  const [health, setHealth] = useState('checking');

  const notify = useCallback((message) => {
    setToast(message);
    window.clearTimeout(notify.timer);
    notify.timer = window.setTimeout(() => setToast(''), 3300);
  }, []);

  const request = useCallback((path, options = {}) => api(path, { ...options, token }), [token]);
  const logout = () => {
    sessionStorage.removeItem('goanest_admin_token');
    sessionStorage.removeItem('goanest_admin_user');
    setToken('');
    setUser(null);
  };

  useEffect(() => {
    if (!token) return;
    fetch(`${apiBaseUrl.replace(/\/api\/v1$/, '')}/health`)
      .then((response) => setHealth(response.ok ? 'online' : 'offline'))
      .catch(() => setHealth('offline'));
  }, [token]);

  if (!token || user?.role !== 'admin') {
    return <><Login onLogin={(nextToken, nextUser) => {
      sessionStorage.setItem('goanest_admin_token', nextToken);
      sessionStorage.setItem('goanest_admin_user', JSON.stringify(nextUser));
      setToken(nextToken); setUser(nextUser);
    }} />{toast && <Toast>{toast}</Toast>}</>;
  }

  const current = nav.find((item) => item.id === page) || nav[0];
  const refresh = () => setVersion((n) => n + 1);

  return <div className="app-shell">
    <aside className={`sidebar ${drawer ? 'sidebar-open' : ''}`}>
      <div className="brand-row">
        <div className="brand-mark"><House size={19} strokeWidth={2.5} /></div>
        <div><div className="brand-name">goanest<span>.</span></div><div className="brand-sub">ADMIN CONSOLE</div></div>
        <button className="icon-button sidebar-close" onClick={() => setDrawer(false)} aria-label="Close menu"><X size={18} /></button>
      </div>
      <div className="workspace-card"><div className="workspace-avatar">G</div><div className="workspace-copy"><strong>GoaNest stays</strong><span>Management workspace</span></div><ChevronDown size={15} /></div>
      {['Workspace', 'Manage'].map((group) => <div className="nav-group" key={group}>
        <div className="nav-label">{group}</div>
        {nav.filter((item) => item.group === group).map((item) => <button key={item.id} className={`nav-item ${page === item.id ? 'selected' : ''}`} onClick={() => { setPage(item.id); setDrawer(false); }}>
          <item.icon size={18} strokeWidth={1.9} /><span>{item.label}</span>{item.id === 'bookings' && <span className="nav-dot" />}
        </button>)}
      </div>)}
      <div className="sidebar-spacer" />
      <div className="side-tip"><div className="tip-icon"><Compass size={17} /></div><strong>Curate the GoaNest experience</strong><p>Properties and categories you publish shape what guests discover.</p><button onClick={() => setPage('properties')}>Manage listings <ChevronRight size={14} /></button></div>
      <div className="sidebar-footer"><div className="avatar admin-avatar">{initials(user.name || user.email)}</div><div className="profile-mini"><strong>{user.name || 'Administrator'}</strong><span>Administrator</span></div><button className="icon-button logout-button" onClick={logout} title="Sign out"><LogOut size={17} /></button></div>
    </aside>
    {drawer && <button className="mobile-scrim" onClick={() => setDrawer(false)} aria-label="Close menu" />}
    <main className="main-area">
      <header className="topbar">
        <div className="breadcrumb"><button className="icon-button menu-trigger" onClick={() => setDrawer(true)} aria-label="Open menu"><Menu size={20} /></button><span>Admin</span><ChevronRight size={14} /><strong>{current.label}</strong></div>
        <div className="top-actions"><div className={`connection ${health}`}><span className="connection-pulse" />{health === 'checking' ? 'Connecting' : health === 'online' ? 'API connected' : 'API offline'}</div><button className="icon-button top-bell" aria-label="Notifications"><Bell size={18} /><i /></button><div className="top-divider" /><div className="avatar top-avatar">{initials(user.name || user.email)}</div></div>
      </header>
      <section className="page-content" key={page}>
        {page === 'overview' && <Overview request={request} version={version} notify={notify} onNavigate={setPage} />}
        {page === 'properties' && <Properties request={request} version={version} notify={notify} working={working} setWorking={setWorking} />}
        {page === 'bookings' && <Bookings request={request} version={version} notify={notify} working={working} setWorking={setWorking} />}
        {page === 'categories' && <Categories request={request} version={version} notify={notify} working={working} setWorking={setWorking} />}
        {page === 'people' && <People request={request} version={version} notify={notify} working={working} setWorking={setWorking} />}
        {page === 'reviews' && <Reviews request={request} version={version} notify={notify} working={working} setWorking={setWorking} />}
      </section>
    </main>
    {toast && <Toast>{toast}</Toast>}
  </div>;
}

function Login({ onLogin }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  async function submit(event) {
    event.preventDefault(); setError(''); setBusy(true);
    try {
      const result = await api('/auth/login', { method: 'POST', body: JSON.stringify({ email, password }) });
      if (result.user?.role !== 'admin') throw new Error('This account does not have admin access.');
      onLogin(result.accessToken, result.user);
    } catch (err) { setError(err.message); }
    finally { setBusy(false); }
  }
  return <div className="login-page"><div className="login-art"><div className="art-orb orb-one" /><div className="art-orb orb-two" /><div className="login-brand"><div className="brand-mark"><House size={19} strokeWidth={2.5} /></div><div className="brand-name">goanest<span>.</span></div></div><div className="art-content"><div className="eyebrow"><span /> YOUR GOA, WELL HOSTED</div><h1>Every great stay<br />starts <em>right here.</em></h1><p>Bring GoaNest’s guest experience to life, one thoughtfully managed stay at a time.</p><div className="art-stats"><div><strong>01</strong><span>Manage your<br />stays</span></div><i /><div><strong>02</strong><span>Welcome more<br />guests</span></div><i /><div><strong>03</strong><span>Grow your<br />community</span></div></div></div><div className="art-footer"><span>© 2026 GoaNest</span><span>Made for the good days.</span></div></div><div className="login-panel"><div className="login-box"><div className="mobile-login-brand"><div className="brand-mark"><House size={18} /></div><div className="brand-name">goanest<span>.</span></div></div><div className="login-icon"><ShieldCheck size={21} /></div><div className="eyebrow login-eyebrow">ADMINISTRATOR ACCESS</div><h2>Welcome back</h2><p className="login-description">Sign in to manage your GoaNest workspace.</p><form onSubmit={submit} className="login-form"><label>Email address<div className="input-wrap"><Users size={17} /><input type="email" autoComplete="username" placeholder="you@goanest.com" value={email} onChange={(e) => setEmail(e.target.value)} required /></div></label><label>Password<div className="input-wrap"><ShieldCheck size={17} /><input type={showPassword ? 'text' : 'password'} autoComplete="current-password" placeholder="Enter your password" value={password} onChange={(e) => setPassword(e.target.value)} required /><button type="button" className="input-action" onClick={() => setShowPassword(!showPassword)}>{showPassword ? <EyeOff size={17} /> : <Eye size={17} />}</button></div></label>{error && <div className="form-error">{error}</div>}<button className="primary-button login-submit" disabled={busy}>{busy ? <LoaderCircle size={17} className="spin" /> : <>Sign in to workspace <ArrowUpRight size={17} /></>}</button></form><div className="login-note"><ShieldCheck size={15} /> Secure access is limited to GoaNest administrators.</div></div><div className="login-panel-footer"><span>Need help signing in?</span><a href="mailto:support@goanest.com">Contact support</a></div></div></div>;
}

function PageHeading({ eyebrow, title, subtitle, actions }) {
  return <div className="page-heading"><div><div className="eyebrow">{eyebrow}</div><h1>{title}</h1><p>{subtitle}</p></div><div className="heading-actions">{actions}</div></div>;
}
function Toast({ children }) { return <div className="toast"><Check size={17} />{children}</div>; }
function ErrorState({ message, retry }) { return <div className="error-state"><div className="error-mark"><CircleHelp size={20} /></div><strong>We couldn't load this view</strong><p>{message}</p><button className="secondary-button" onClick={retry}><RefreshCw size={15} /> Try again</button></div>; }
function Loading() { return <div className="loading-state"><LoaderCircle size={22} className="spin" /><span>Loading workspace data…</span></div>; }
function Avatar({ name, image, color = '' }) { return image ? <img className="avatar" src={image} alt="" /> : <div className={`avatar ${color}`}>{initials(name)}</div>; }
function Status({ children }) { return <span className={`status status-${String(children || '').toLowerCase()}`}>{children}</span>; }
function Empty({ title, text, action }) { return <div className="empty-state"><div className="empty-mark"><House size={19} /></div><strong>{title}</strong><span>{text}</span>{action}</div>; }
function Modal({ title, subtitle, close, children, size = '' }) { return <div className="modal-backdrop" onMouseDown={(e) => { if (e.target === e.currentTarget) close(); }}><div className={`modal ${size}`}><div className="modal-head"><div><h2>{title}</h2>{subtitle && <p>{subtitle}</p>}</div><button className="icon-button" onClick={close}><X size={19} /></button></div>{children}</div></div>; }
function Pager({ page, pages, setPage }) { return <div className="pager"><span>Page <b>{page}</b> of <b>{pages || 1}</b></span><div><button className="icon-button" disabled={page <= 1} onClick={() => setPage(page - 1)}><ChevronLeft size={18} /></button><button className="icon-button" disabled={page >= pages} onClick={() => setPage(page + 1)}><ChevronRight size={18} /></button></div></div>; }

function Overview({ request, version, notify, onNavigate }) {
  const [data, setData] = useState(null); const [error, setError] = useState(''); const [loading, setLoading] = useState(true);
  useEffect(() => { setLoading(true); request('/admin/overview').then(setData).catch((e) => setError(e.message)).finally(() => setLoading(false)); }, [request, version]);
  if (loading) return <><PageHeading eyebrow="MONDAY, SEPTEMBER 29" title="A good day to host." subtitle="Here’s what’s happening across GoaNest today." /><Loading /></>;
  if (error) return <><PageHeading eyebrow="YOUR WORKSPACE" title="A good day to host." subtitle="Here’s what’s happening across GoaNest today." /><ErrorState message={error} retry={() => window.location.reload()} /></>;
  const metrics = data?.metrics || {};
  const cards = [
    { title: 'Total revenue', value: money(metrics.revenue), note: 'Confirmed & completed stays', icon: Activity, tone: 'mint' },
    { title: 'Total bookings', value: metrics.bookings || 0, note: `${metrics.pendingBookings || 0} awaiting attention`, icon: CalendarDays, tone: 'lavender' },
    { title: 'Active properties', value: metrics.activeProperties || 0, note: `${metrics.properties || 0} total listings`, icon: House, tone: 'peach' },
    { title: 'Guest community', value: metrics.users || 0, note: `${metrics.hosts || 0} trusted hosts`, icon: Users, tone: 'blue' },
  ];
  const statusList = Object.entries(data?.bookingsByStatus || {});
  const total = Math.max(statusList.reduce((sum, [, val]) => sum + val, 0), 1);
  return <>
    <PageHeading eyebrow="MONDAY, SEPTEMBER 29" title="A good day to host." subtitle="Here’s what’s happening across GoaNest today." actions={<><button className="secondary-button" onClick={() => window.location.reload()}><RefreshCw size={15} /> Refresh</button><button className="primary-button" onClick={() => onNavigate('properties')}><Plus size={17} /> Add a property</button></>} />
    <div className="metric-grid">{cards.map(({ title, value, note, icon: Icon, tone }, index) => <div className={`metric-card metric-${tone}`} key={title}><div className="metric-top"><span>{title}</span><span className="metric-icon"><Icon size={19} /></span></div><div className="metric-value">{value}</div><div className="metric-note">{index === 0 ? <ArrowUpRight size={14} /> : <span className="metric-note-dot" />}{note}</div><div className="metric-sparkline"><i /><i /><i /><i /><i /><i /><i /><i /><i /><i /></div></div>)}</div>
    <div className="dashboard-grid"><section className="surface status-panel"><div className="section-head"><div><h2>Booking pulse</h2><p>Stay status across all reservations</p></div><button className="text-button" onClick={() => onNavigate('bookings')}>View bookings <ArrowUpRight size={14} /></button></div><div className="status-total"><strong>{metrics.bookings || 0}</strong><span>reservations<br />in total</span></div><div className="status-bars">{statusList.length ? statusList.map(([key, count]) => <div className="status-bar-row" key={key}><div className="status-bar-label"><span><i className={`legend-dot legend-${key}`} />{key}</span><b>{count}</b></div><div className="status-bar-track"><i className={`legend-${key}`} style={{ width: `${Math.max(4, count / total * 100)}%` }} /></div></div>) : <div className="muted-empty">Bookings will appear here as guests reserve a stay.</div>}</div><div className="pulse-footer"><span><span className="live-dot" /> Live data</span><span>From your GoaNest database</span></div></section><section className="surface recent-panel"><div className="section-head"><div><h2>Recent reservations</h2><p>The latest guest activity</p></div><button className="icon-button" onClick={() => onNavigate('bookings')}><Ellipsis size={19} /></button></div>{data?.recentBookings?.length ? <div className="recent-list">{data.recentBookings.map((booking) => <div className="recent-booking" key={booking._id}><div className="recent-image">{booking.property?.images?.[0]?.url ? <img src={booking.property.images[0].url} alt="" /> : <House size={17} />}</div><div className="recent-main"><strong>{booking.guest?.name || 'Guest'}</strong><span>{booking.property?.title || 'Property'} · {date(booking.checkIn)}</span></div><div className="recent-side"><b>{money(booking.totalPrice)}</b><Status>{booking.status}</Status></div></div>)}</div> : <Empty title="No reservations yet" text="New guest bookings will appear here." />}</section></div>
    <div className="dashboard-footnote"><div><BadgeCheck size={16} /><span>Properties and categories published here appear in the GoaNest app.</span></div><button onClick={() => onNavigate('categories')}>Manage discovery categories <ChevronRight size={15} /></button></div>
  </>;
}

function Properties({ request, version, notify, working, setWorking }) {
  const [result, setResult] = useState(null); const [hosts, setHosts] = useState([]); const [categories, setCategories] = useState([]);
  const [error, setError] = useState(''); const [query, setQuery] = useState(''); const [statusFilter, setStatusFilter] = useState('all'); const [page, setPage] = useState(1); const [modal, setModal] = useState(null); const [search, setSearch] = useState('');
  const load = useCallback(() => {
    setError('');
    Promise.all([
      request(`/admin/properties?page=${page}&limit=8&status=${statusFilter === 'all' ? '' : statusFilter}&search=${encodeURIComponent(search)}`),
      request('/admin/users?role=host&limit=100'), request('/admin/categories'),
    ]).then(([props, people, cats]) => { setResult(props); setHosts(people.users || []); setCategories(cats.categories || []); }).catch((e) => setError(e.message));
  }, [request, page, statusFilter, search]);
  useEffect(load, [load, version]);
  async function saveProperty(form) {
    setWorking(true);
    try {
      const body = {
        title: form.title.trim(), description: form.description.trim(), propertyType: form.propertyType,
        hostId: form.hostId || undefined, category: form.category || null,
        location: { address: form.address.trim(), city: form.city.trim(), state: form.state.trim(), country: form.country.trim(), zipCode: form.zipCode.trim() || undefined },
        pricePerNight: Number(form.pricePerNight), maxGuests: Number(form.maxGuests), bedrooms: Number(form.bedrooms), beds: Number(form.beds), bathrooms: Number(form.bathrooms),
        amenities: form.amenities.split(',').map((v) => v.trim()).filter(Boolean),
        images: form.imageUrl ? [{ url: form.imageUrl.trim(), isPrimary: true, caption: form.title.trim() }] : [],
        isFeatured: form.isFeatured, isActive: form.isActive,
      };
      await request(modal?.item ? `/properties/${modal.item._id}` : '/properties', { method: modal?.item ? 'PUT' : 'POST', body: JSON.stringify(body) });
      setModal(null); notify(modal?.item ? 'Property changes saved' : 'Property added to GoaNest'); load();
    } catch (e) { notify(e.message); }
    finally { setWorking(false); }
  }
  async function toggleProperty(item) {
    setWorking(true);
    try { await request(`/properties/${item._id}`, { method: 'PUT', body: JSON.stringify({ isActive: !item.isActive }) }); notify(item.isActive ? 'Property unpublished' : 'Property published'); load(); }
    catch (e) { notify(e.message); } finally { setWorking(false); }
  }
  return <>
    <PageHeading eyebrow="STAY COLLECTION" title="Properties" subtitle="Create and curate the stays guests discover in the app." actions={<button className="primary-button" onClick={() => setModal({ item: null })}><Plus size={17} /> Add property</button>} />
    <div className="summary-strip"><div><div className="summary-mark"><House size={17} /></div><span><b>{result?.total ?? '—'}</b> listings in your collection</span></div><span className="summary-separator" /><div><span className="live-dot" /><span>Changes update app discovery immediately</span></div></div>
    <section className="surface data-surface"><div className="table-toolbar"><div className="table-tabs"><button className={statusFilter === 'all' ? 'active' : ''} onClick={() => { setStatusFilter('all'); setPage(1); }}>All properties</button><button className={statusFilter === 'active' ? 'active' : ''} onClick={() => { setStatusFilter('active'); setPage(1); }}>Published</button><button className={statusFilter === 'inactive' ? 'active' : ''} onClick={() => { setStatusFilter('inactive'); setPage(1); }}>Unpublished</button></div><form className="search-box" onSubmit={(e) => { e.preventDefault(); setSearch(query); setPage(1); }}><Search size={16} /><input placeholder="Search listings" value={query} onChange={(e) => setQuery(e.target.value)} /><button aria-label="Search"><ChevronRight size={15} /></button></form><button className="square-button filter-button"><SlidersHorizontal size={16} /><span>Filters</span></button></div>
      {error ? <ErrorState message={error} retry={load} /> : !result ? <Loading /> : result.properties?.length ? <><div className="table-scroll"><table><thead><tr><th>PROPERTY</th><th>LOCATION</th><th>HOST</th><th>PRICE / NIGHT</th><th>STATUS</th><th /></tr></thead><tbody>{result.properties.map((item) => <tr key={item._id}><td><div className="property-cell"><div className="property-thumb">{item.images?.[0]?.url ? <img src={item.images[0].url} alt="" /> : <House size={17} />}</div><div className="cell-main"><strong>{item.title}</strong><span>{item.propertyType} {item.isFeatured && <i className="featured-label"><Star size={11} fill="currentColor" /> Featured</i>}</span></div></div></td><td><div className="location-cell"><MapPin size={14} />{item.location?.city || '—'}, {item.location?.country || ''}</div></td><td><div className="person-cell"><Avatar name={item.host?.name} image={item.host?.avatar} /><span>{item.host?.name || 'Unassigned'}</span></div></td><td><b className="price-cell">{money(item.pricePerNight)}</b></td><td><Status>{item.isActive ? 'Published' : 'Unpublished'}</Status></td><td><div className="row-actions"><button className="small-link" onClick={() => setModal({ item })}>Edit</button><button className="icon-button" title={item.isActive ? 'Unpublish' : 'Publish'} onClick={() => toggleProperty(item)}><MoreHorizontal size={18} /></button></div></td></tr>)}</tbody></table></div><Pager page={result.page || page} pages={result.pages || 1} setPage={setPage} /></> : <Empty title="No properties found" text="Add your first stay to start shaping the GoaNest discovery experience." action={<button className="primary-button" onClick={() => setModal({ item: null })}><Plus size={16} /> Add a property</button>} />}
    </section>
    {modal && <PropertyModal item={modal.item} hosts={hosts} categories={categories} close={() => setModal(null)} save={saveProperty} busy={working} />}
  </>;
}

function PropertyModal({ item, hosts, categories, close, save, busy }) {
  const image = item?.images?.[0]?.url || '';
  const [form, setForm] = useState({ title: item?.title || '', description: item?.description || '', propertyType: item?.propertyType || 'villa', hostId: item?.host?._id || '', category: item?.category?._id || '', address: item?.location?.address || '', city: item?.location?.city || '', state: item?.location?.state || 'Goa', country: item?.location?.country || 'India', zipCode: item?.location?.zipCode || '', pricePerNight: item?.pricePerNight ?? '', maxGuests: item?.maxGuests ?? 2, bedrooms: item?.bedrooms ?? 1, beds: item?.beds ?? 1, bathrooms: item?.bathrooms ?? 1, amenities: item?.amenities?.join(', ') || 'Wi-Fi, Air conditioning', imageUrl: image, isFeatured: item?.isFeatured || false, isActive: item?.isActive ?? true });
  const set = (key) => (event) => setForm((f) => ({ ...f, [key]: event.target.type === 'checkbox' ? event.target.checked : event.target.value }));
  return <Modal title={item ? 'Edit property' : 'Add a property'} subtitle="The details guests will see in the GoaNest app." close={close} size="modal-wide"><form className="property-form" onSubmit={(e) => { e.preventDefault(); save(form); }}>
    <div className="form-section-title"><span>01</span><div><strong>Tell us about this stay</strong><small>Give the listing a name guests will remember.</small></div></div><div className="form-grid"><label className="field full-field">Property name<input value={form.title} onChange={set('title')} placeholder="e.g. The Palm House, Assagao" required maxLength="100" /></label><label className="field full-field">Description<textarea value={form.description} onChange={set('description')} placeholder="What makes this stay special?" rows="3" required maxLength="2000" /></label><label className="field">Property type<select value={form.propertyType} onChange={set('propertyType')}>{['apartment', 'house', 'hotel', 'villa', 'cottage', 'cabin', 'treehouse', 'castle', 'tent', 'other'].map((x) => <option key={x} value={x}>{x[0].toUpperCase() + x.slice(1)}</option>)}</select></label><label className="field">Category<select value={form.category} onChange={set('category')}><option value="">No category</option>{categories.filter((x) => x.isActive).map((x) => <option key={x._id} value={x._id}>{x.icon ? `${x.icon} ` : ''}{x.name}</option>)}</select></label><label className="field">Host<select value={form.hostId} onChange={set('hostId')}><option value="">Assign admin as host</option>{hosts.map((x) => <option key={x._id} value={x._id}>{x.name} · {x.email}</option>)}</select></label></div>
    <div className="form-section-title"><span>02</span><div><strong>Where guests will stay</strong><small>A clear location helps guests plan their trip.</small></div></div><div className="form-grid"><label className="field full-field">Street address<input value={form.address} onChange={set('address')} placeholder="Address or neighborhood" required /></label><label className="field">City<input value={form.city} onChange={set('city')} placeholder="Assagao" required /></label><label className="field">State / region<input value={form.state} onChange={set('state')} placeholder="Goa" /></label><label className="field">Country<input value={form.country} onChange={set('country')} required /></label><label className="field">ZIP / postal code<input value={form.zipCode} onChange={set('zipCode')} /></label></div>
    <div className="form-section-title"><span>03</span><div><strong>Stay details & pricing</strong><small>Set a clear rate and the basics for your guests.</small></div></div><div className="form-grid form-grid-four"><label className="field">Price per night (₹)<input type="number" min="0" value={form.pricePerNight} onChange={set('pricePerNight')} required /></label><label className="field">Max guests<input type="number" min="1" value={form.maxGuests} onChange={set('maxGuests')} required /></label><label className="field">Bedrooms<input type="number" min="0" value={form.bedrooms} onChange={set('bedrooms')} required /></label><label className="field">Beds<input type="number" min="0" value={form.beds} onChange={set('beds')} required /></label><label className="field">Bathrooms<input type="number" min="0" value={form.bathrooms} onChange={set('bathrooms')} required /></label><label className="field full-field">Amenities<input value={form.amenities} onChange={set('amenities')} placeholder="Separate amenities with commas" /></label><label className="field full-field">Cover image URL<input type="url" value={form.imageUrl} onChange={set('imageUrl')} placeholder="https://…" /></label></div>
    <div className="form-switches"><label><input type="checkbox" checked={form.isFeatured} onChange={set('isFeatured')} /><span><Star size={15} /> Highlight in guest discovery</span></label><label><input type="checkbox" checked={form.isActive} onChange={set('isActive')} /><span><Eye size={15} /> Publish this property</span></label></div><div className="modal-actions"><button type="button" className="secondary-button" onClick={close}>Cancel</button><button className="primary-button" disabled={busy}>{busy ? <LoaderCircle size={16} className="spin" /> : <Check size={16} />}{item ? 'Save changes' : 'Add property'}</button></div>
  </form></Modal>;
}

function Bookings({ request, version, notify, working, setWorking }) {
  const [result, setResult] = useState(null); const [error, setError] = useState(''); const [status, setStatus] = useState(''); const [page, setPage] = useState(1);
  const load = useCallback(() => { setError(''); request(`/admin/bookings?page=${page}&limit=10${status ? `&status=${status}` : ''}`).then(setResult).catch((e) => setError(e.message)); }, [request, page, status]);
  useEffect(load, [load, version]);
  async function update(item, next) { setWorking(true); try { await request(`/admin/bookings/${item._id}/status`, { method: 'PATCH', body: JSON.stringify({ status: next }) }); notify('Reservation status updated'); load(); } catch (e) { notify(e.message); } finally { setWorking(false); } }
  return <><PageHeading eyebrow="GUEST JOURNEYS" title="Bookings" subtitle="Track reservations and keep every stay on course." actions={<button className="secondary-button" onClick={load}><RefreshCw size={15} /> Refresh</button>} /><div className="booking-summary"><div><span className="summary-mark"><CalendarDays size={17} /></span><span><b>{result?.total ?? '—'}</b> reservations</span></div><label className="select-filter"><Filter size={15} /><select value={status} onChange={(e) => { setStatus(e.target.value); setPage(1); }}><option value="">All statuses</option>{['pending', 'confirmed', 'completed', 'cancelled'].map((s) => <option key={s} value={s}>{s[0].toUpperCase() + s.slice(1)}</option>)}</select><ChevronDown size={14} /></label></div><section className="surface data-surface">{error ? <ErrorState message={error} retry={load} /> : !result ? <Loading /> : result.bookings?.length ? <><div className="table-scroll"><table><thead><tr><th>GUEST & STAY</th><th>TRAVEL DATES</th><th>GUESTS</th><th>BOOKING TOTAL</th><th>STATUS</th><th>UPDATE</th></tr></thead><tbody>{result.bookings.map((b) => <tr key={b._id}><td><div className="booking-person"><Avatar name={b.guest?.name} image={b.guest?.avatar} /><div className="cell-main"><strong>{b.guest?.name || 'Guest'}</strong><span>{b.property?.title || 'Property'}</span></div></div></td><td><div className="date-cell">{date(b.checkIn)}<span>to</span>{date(b.checkOut)}</div></td><td><span className="guest-count"><Users size={14} />{(b.guests?.adults || 1) + (b.guests?.children || 0)}</span></td><td><b className="price-cell">{money(b.totalPrice)}</b></td><td><Status>{b.status}</Status></td><td><select className="inline-status" value={b.status} onChange={(e) => update(b, e.target.value)} disabled={working}>{['pending', 'confirmed', 'completed', 'cancelled'].map((s) => <option key={s} value={s}>{s}</option>)}</select></td></tr>)}</tbody></table></div><Pager page={result.page || page} pages={result.pages || 1} setPage={setPage} /></> : <Empty title="No bookings yet" text="Guest reservations will be listed here." />}</section></>;
}

function Categories({ request, version, notify, working, setWorking }) {
  const [items, setItems] = useState(null); const [error, setError] = useState(''); const [modal, setModal] = useState(null);
  const load = useCallback(() => { setError(''); request('/admin/categories').then((r) => setItems(r.categories || [])).catch((e) => setError(e.message)); }, [request]);
  useEffect(load, [load, version]);
  async function save(form) { setWorking(true); try { await request(modal?.item ? `/admin/categories/${modal.item._id}` : '/admin/categories', { method: modal?.item ? 'PUT' : 'POST', body: JSON.stringify(form) }); setModal(null); notify(modal?.item ? 'Category updated' : 'Category added'); load(); } catch (e) { notify(e.message); } finally { setWorking(false); } }
  async function archive(item) { setWorking(true); try { await request(`/admin/categories/${item._id}`, { method: 'DELETE' }); notify('Category archived'); load(); } catch (e) { notify(e.message); } finally { setWorking(false); } }
  return <><PageHeading eyebrow="GUEST DISCOVERY" title="Categories" subtitle="Organize the themes and stays guests explore." actions={<button className="primary-button" onClick={() => setModal({ item: null })}><Plus size={17} /> Add category</button>} /><div className="summary-strip"><div><span className="summary-mark"><Tag size={17} /></span><span><b>{items?.length ?? '—'}</b> discovery categories</span></div><span className="summary-separator" /><span>Active categories appear in the app’s Explore experience.</span></div>{error ? <ErrorState message={error} retry={load} /> : !items ? <Loading /> : items.length ? <div className="category-grid">{items.map((item) => <article className={`category-card ${!item.isActive ? 'category-muted' : ''}`} key={item._id}><div className="category-card-top"><div className="category-emoji">{item.icon || '✦'}</div><Status>{item.isActive ? 'Active' : 'Archived'}</Status></div><h3>{item.name}</h3><p>{item.description || 'A guest discovery collection.'}</p><div className="category-card-footer"><span><code>/{item.slug}</code></span><div><button className="small-link" onClick={() => setModal({ item })}>Edit</button>{item.isActive && <button className="small-link danger-link" onClick={() => archive(item)}>Archive</button>}</div></div></article>)}</div> : <Empty title="No categories yet" text="Add a discovery theme to help guests find the right stay." action={<button className="primary-button" onClick={() => setModal({ item: null })}><Plus size={16} /> Add category</button>} />}{modal && <CategoryModal item={modal.item} close={() => setModal(null)} save={save} busy={working} />}</>;
}
function CategoryModal({ item, close, save, busy }) {
  const [form, setForm] = useState({ name: item?.name || '', slug: item?.slug || '', icon: item?.icon || '', description: item?.description || '', isActive: item?.isActive ?? true });
  const set = (key) => (e) => setForm((f) => ({ ...f, [key]: e.target.value }));
  return <Modal title={item ? 'Edit category' : 'New category'} subtitle="Categories help guests explore stays by feeling and style." close={close}><form className="category-form" onSubmit={(e) => { e.preventDefault(); save(form); }}><label className="field">Category name<input value={form.name} onChange={(e) => setForm((f) => ({ ...f, name: e.target.value, slug: item ? f.slug : e.target.value.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '') }))} placeholder="Beachfront" required maxLength="50" /></label><div className="form-grid"><label className="field">URL slug<input value={form.slug} onChange={set('slug')} placeholder="beachfront" required /></label><label className="field">Icon or emoji<input value={form.icon} onChange={set('icon')} placeholder="🏖️" /></label></div><label className="field">Short description<textarea rows="3" maxLength="200" value={form.description} onChange={set('description')} placeholder="Properties right by the sea" /></label><label className="check-row"><input type="checkbox" checked={form.isActive} onChange={(e) => setForm((f) => ({ ...f, isActive: e.target.checked }))} /> Show this category in guest discovery</label><div className="modal-actions"><button type="button" className="secondary-button" onClick={close}>Cancel</button><button className="primary-button" disabled={busy}><Check size={16} />{item ? 'Save category' : 'Create category'}</button></div></form></Modal>;
}

function People({ request, version, notify, working, setWorking }) {
  const [result, setResult] = useState(null); const [role, setRole] = useState(''); const [page, setPage] = useState(1); const [searchInput, setSearchInput] = useState(''); const [search, setSearch] = useState(''); const [error, setError] = useState('');
  const load = useCallback(() => { setError(''); request(`/admin/users?page=${page}&limit=10&role=${role}&search=${encodeURIComponent(search)}`).then(setResult).catch((e) => setError(e.message)); }, [request, page, role, search]);
  useEffect(load, [load, version]);
  async function toggle(person) { setWorking(true); try { await request(`/admin/users/${person._id}/status`, { method: 'PATCH', body: JSON.stringify({ isActive: !person.isActive }) }); notify(person.isActive ? 'Account paused' : 'Account reactivated'); load(); } catch (e) { notify(e.message); } finally { setWorking(false); } }
  return <><PageHeading eyebrow="COMMUNITY" title="Guests & hosts" subtitle="The people who make each GoaNest stay memorable." actions={<div className="people-count"><Users size={16} />{result?.total ?? '—'} members</div>} /><div className="surface data-surface"><div className="table-toolbar"><div className="table-tabs"><button className={!role ? 'active' : ''} onClick={() => { setRole(''); setPage(1); }}>Everyone</button><button className={role === 'user' ? 'active' : ''} onClick={() => { setRole('user'); setPage(1); }}>Guests</button><button className={role === 'host' ? 'active' : ''} onClick={() => { setRole('host'); setPage(1); }}>Hosts</button></div><form className="search-box" onSubmit={(e) => { e.preventDefault(); setSearch(searchInput); setPage(1); }}><Search size={16} /><input value={searchInput} onChange={(e) => setSearchInput(e.target.value)} placeholder="Search people" /><button aria-label="Search"><ChevronRight size={15} /></button></form></div>{error ? <ErrorState message={error} retry={load} /> : !result ? <Loading /> : result.users?.length ? <><div className="table-scroll"><table><thead><tr><th>MEMBER</th><th>ROLE</th><th>LOCATION</th><th>JOINED</th><th>STATUS</th><th /></tr></thead><tbody>{result.users.map((person) => <tr key={person._id}><td><div className="person-cell"><Avatar name={person.name} image={person.avatar} /><div className="cell-main"><strong>{person.name}</strong><span>{person.email}</span></div></div></td><td><span className={`role-tag role-${person.role}`}>{person.role}</span></td><td>{person.location || '—'}</td><td>{date(person.createdAt)}</td><td><Status>{person.isActive ? 'Active' : 'Paused'}</Status></td><td><button className={`small-link ${person.isActive ? 'danger-link' : ''}`} disabled={working} onClick={() => toggle(person)}>{person.isActive ? 'Pause access' : 'Reactivate'}</button></td></tr>)}</tbody></table></div><Pager page={result.page || page} pages={result.pages || 1} setPage={setPage} /></> : <Empty title="No members match" text="Try a different name, email, or role." />}</div></>;
}

function Reviews({ request, version, notify, working, setWorking }) {
  const [result, setResult] = useState(null); const [page, setPage] = useState(1); const [error, setError] = useState('');
  const load = useCallback(() => { setError(''); request(`/admin/reviews?page=${page}&limit=8`).then(setResult).catch((e) => setError(e.message)); }, [request, page]);
  useEffect(load, [load, version]);
  async function remove(item) { if (!window.confirm('Remove this review from the guest app?')) return; setWorking(true); try { await request(`/admin/reviews/${item._id}`, { method: 'DELETE' }); notify('Review removed and listing rating refreshed'); load(); } catch (e) { notify(e.message); } finally { setWorking(false); } }
  return <><PageHeading eyebrow="GUEST FEEDBACK" title="Reviews" subtitle="Keep an eye on the feedback guests leave after a stay." actions={<div className="people-count"><Star size={16} /> Guest voices</div>} />{error ? <ErrorState message={error} retry={load} /> : !result ? <Loading /> : result.reviews?.length ? <><div className="review-grid">{result.reviews.map((review) => <article className="surface review-card" key={review._id}><div className="review-top"><div className="person-cell"><Avatar name={review.guest?.name} image={review.guest?.avatar} /><div className="cell-main"><strong>{review.guest?.name || 'Guest'}</strong><span>{review.property?.title || 'Property'} · {date(review.createdAt)}</span></div></div><button className="icon-button" onClick={() => remove(review)} disabled={working} title="Remove review"><MoreHorizontal size={18} /></button></div><div className="review-stars">{Array.from({ length: 5 }, (_, i) => <Star key={i} size={14} fill={i < review.rating ? 'currentColor' : 'none'} />)}<b>{Number(review.rating).toFixed(1)}</b></div><p>“{review.comment || 'Guest left a rating without a written comment.'}”</p><div className="review-labels">{['cleanliness', 'accuracy', 'communication', 'location', 'value'].filter((x) => review[x]).map((x) => <span key={x}>{x} <b>{review[x]}</b></span>)}</div></article>)}</div><div className="surface review-pager"><span>{result.total} guest reviews</span><Pager page={result.page || page} pages={result.pages || 1} setPage={setPage} /></div></> : <Empty title="No reviews yet" text="Guest feedback will show up here after completed stays." />}</>;
}

export default App;
