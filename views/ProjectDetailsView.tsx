
import React, { useState, useEffect, useMemo } from 'react';
import { 
  ArrowLeft, ArrowRight, Calendar, PoundSterling, Users, MapPin, 
  LayoutDashboard, CheckSquare, FileText, Layers, 
  MoreHorizontal, CloudRain, AlertTriangle, 
  Plus, Filter, Download, Search, Box, HardHat, Sparkles, Image as ImageIcon,
  RotateCw, ZoomIn, MousePointer2, Ruler, Eye, EyeOff, Maximize2, Settings,
  MessageSquare, Send, Paperclip, User, Clock, CheckCircle2, XCircle,
  Camera, Hammer, FilePlus, Clipboard, Siren, ChevronRight, ChevronDown,
  Building, HelpCircle, List
} from 'lucide-react';
import { useProjects } from '../contexts/ProjectContext';
import { Project, Task, TeamMember, ProjectDocument } from '../types';

interface ProjectDetailsViewProps {
  projectId: string | null;
  onBack: () => void;
}

type Tab = 'OVERVIEW' | 'TASKS' | 'PHOTOS' | 'TEAM' | 'DOCUMENTS' | 'FINANCIALS' | 'BIM_MODEL' | 'RFI';

const ProjectDetailsView: React.FC<ProjectDetailsViewProps> = ({ projectId, onBack }) => {
  const { getProject, tasks, teamMembers, documents } = useProjects();
  const [activeTab, setActiveTab] = useState<Tab>('OVERVIEW');
  const [project, setProject] = useState<Project | undefined>(undefined);

  // Derived State
  const [projectTasks, setProjectTasks] = useState<Task[]>([]);
  const [projectTeam, setProjectTeam] = useState<TeamMember[]>([]);
  const [projectDocs, setProjectDocs] = useState<ProjectDocument[]>([]);

  // Reset tab when project ID changes
  useEffect(() => {
    setActiveTab('OVERVIEW');
  }, [projectId]);

  useEffect(() => {
    if (projectId) {
      const p = getProject(projectId);
      setProject(p);
      if (p) {
          setProjectTasks(tasks.filter(t => t.projectId === p.id));
          setProjectTeam(teamMembers.filter(m => m.projectId === p.id));
          setProjectDocs(documents.filter(d => d.projectId === p.id));
      }
    }
  }, [projectId, getProject, tasks, teamMembers, documents]);

  if (!project) {
    return (
        <div className="flex flex-col items-center justify-center h-full bg-zinc-50 p-6 animate-in fade-in duration-300">
            <div className="bg-white p-10 rounded-2xl shadow-xl border border-zinc-200/60 max-w-md w-full text-center">
                <div className="w-20 h-20 bg-red-50 rounded-full flex items-center justify-center mb-6 mx-auto shadow-inner">
                    <AlertTriangle size={40} className="text-red-500" strokeWidth={1.5} />
                </div>
                <h2 className="text-2xl font-bold text-zinc-900 mb-3">Access Denied</h2>
                <p className="text-zinc-500 mb-8 text-sm leading-relaxed">
                    You do not have permission to view this project, or the project ID is invalid. Please contact your administrator for access.
                </p>
                <button 
                    onClick={onBack}
                    className="w-full py-3.5 bg-zinc-900 hover:bg-zinc-800 text-white rounded-xl font-semibold transition-all shadow-lg shadow-zinc-200 flex items-center justify-center gap-2 group"
                >
                    <ArrowLeft size={18} className="group-hover:-translate-x-1 transition-transform" /> 
                    Return to Dashboard
                </button>
            </div>
        </div>
    );
  }

  const TabButton = ({ id, label, icon: Icon }: { id: Tab, label: string, icon: any }) => (
    <button 
      onClick={() => setActiveTab(id)}
      className={`flex items-center gap-2 px-4 py-3 text-sm font-medium border-b-2 transition-colors ${
        activeTab === id 
          ? 'border-[#0f5c82] text-[#0f5c82]' 
          : 'border-transparent text-zinc-500 hover:text-zinc-700 hover:bg-zinc-50/50'
      }`}
    >
      <Icon size={16} />
      {label}
    </button>
  );

  return (
    <div className="flex flex-col h-full bg-zinc-50">
      {/* Project Header */}
      <div className="bg-white border-b border-zinc-200 px-8 py-6 flex-shrink-0 shadow-sm z-10">
        <div className="flex items-center gap-2 text-zinc-500 text-sm mb-4">
             <button onClick={onBack} className="hover:text-zinc-800 transition-colors">Projects</button>
             <ChevronRight size={14} />
             <span className="text-zinc-900 font-medium">{project.name}</span>
        </div>

        <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
           <div className="flex items-start gap-5">
              <div className="w-16 h-16 bg-zinc-100 rounded-xl flex items-center justify-center text-zinc-400 font-bold text-2xl shadow-inner border border-zinc-200 overflow-hidden">
                 {project.image ? (
                     <img src={project.image} alt={project.name} className="w-full h-full object-cover" />
                 ) : (
                     <Building size={32} />
                 )}
              </div>
              <div>
                 <div className="flex items-center gap-3 mb-1">
                    <h1 className="text-2xl font-bold text-zinc-900 tracking-tight">{project.name}</h1>
                    <span className={`px-2.5 py-0.5 text-xs font-bold uppercase rounded-full border ${
                        project.status === 'Active' ? 'bg-green-50 text-green-700 border-green-200' : 
                        project.status === 'Planning' ? 'bg-blue-50 text-blue-700 border-blue-200' :
                        'bg-zinc-50 text-zinc-600 border-zinc-200'
                    }`}>
                       {project.status}
                    </span>
                 </div>
                 <div className="flex flex-wrap items-center gap-4 text-sm text-zinc-500">
                    <div className="flex items-center gap-1.5">
                       <MapPin size={14} className="text-zinc-400" /> {project.location}
                    </div>
                    <div className="flex items-center gap-1.5">
                       <Calendar size={14} className="text-zinc-400" /> {project.startDate}
                    </div>
                 </div>
              </div>
           </div>

           {/* Weather Widget */}
           {project.weatherLocation && (
             <div className="flex items-center gap-4 bg-white border border-zinc-200 px-4 py-2 rounded-xl shadow-sm">
                 <div className="flex items-center gap-3 border-r border-zinc-100 pr-4">
                     <div className="text-amber-500 bg-amber-50 p-2 rounded-full"><CloudRain size={18} /></div>
                     <div>
                         <div className="text-base font-bold text-zinc-800">{project.weatherLocation.temp}</div>
                         <div className="text-[10px] text-zinc-500 uppercase font-bold">{project.weatherLocation.condition}</div>
                     </div>
                 </div>
                 <div className="flex flex-col justify-center">
                     <span className="text-zinc-900 font-medium text-xs">{project.weatherLocation.city}</span>
                     <span className="text-zinc-400 text-[10px]">Local Site Weather</span>
                 </div>
             </div>
           )}
        </div>

        {/* Navigation Tabs */}
        <div className="flex items-center gap-1 mt-8 border-b border-zinc-100 overflow-x-auto -mb-6 pb-0">
           <TabButton id="OVERVIEW" label="Overview" icon={LayoutDashboard} />
           <TabButton id="TASKS" label="Tasks" icon={CheckSquare} />
           <TabButton id="PHOTOS" label="Photos" icon={Camera} />
           <TabButton id="TEAM" label="Team" icon={Users} />
           <TabButton id="FINANCIALS" label="Financials" icon={PoundSterling} />
           <TabButton id="DOCUMENTS" label="Documents" icon={FileText} />
           <TabButton id="BIM_MODEL" label="BIM & Plans" icon={Layers} />
           <TabButton id="RFI" label="RFIs" icon={AlertTriangle} />
        </div>
      </div>

      {/* Tab Content */}
      <div className="flex-1 overflow-y-auto bg-[#f4f4f5] p-6 md:p-8">
         {activeTab === 'OVERVIEW' && <ProjectOverview project={project} tasks={projectTasks} />}
         {activeTab === 'TASKS' && <ProjectTasks tasks={projectTasks} />}
         {activeTab === 'PHOTOS' && <ProjectPhotos docs={projectDocs} />}
         {activeTab === 'TEAM' && <ProjectTeam team={projectTeam} />}
         {activeTab === 'FINANCIALS' && <ProjectBudget project={project} />}
         {activeTab === 'DOCUMENTS' && <ProjectDocuments docs={projectDocs} />}
         {activeTab === 'BIM_MODEL' && <ProjectBIM />}
         {activeTab === 'RFI' && <ProjectRFI />}
      </div>
    </div>
  );
};

// --- Components ---

const DashboardMetric = ({ label, value, icon: Icon, color, bg }: any) => (
    <div className="bg-white p-6 rounded-2xl border border-zinc-100 shadow-sm flex items-center gap-4 transition-all hover:shadow-md">
        <div className={`p-3 rounded-xl ${bg} ${color}`}>
            <Icon size={24} strokeWidth={1.5} />
        </div>
        <div>
            <div className={`text-2xl font-bold ${label === 'AI Risk Level' ? color : 'text-zinc-900'}`}>{value}</div>
            <div className="text-sm font-medium text-zinc-500">{label}</div>
        </div>
    </div>
);

const QuickActionButton = ({ icon: Icon, label }: any) => (
    <button className="flex flex-col items-center justify-center gap-2 bg-white border border-zinc-200 p-4 rounded-2xl hover:bg-blue-50 hover:border-blue-200 transition-all shadow-sm group">
        <Icon size={20} className="text-zinc-500 group-hover:text-[#0f5c82] transition-colors" />
        <span className="text-xs font-medium text-zinc-700 group-hover:text-[#0f5c82] transition-colors">{label}</span>
    </button>
);

const ProjectOverview = ({ project, tasks }: { project: Project, tasks: Task[] }) => {
    // Mock data to match screenshot vibe
    const metrics = [
        { label: 'Open RFIs', value: 2, icon: HelpCircle, color: 'text-red-500', bg: 'bg-red-50' },
        { label: 'Overdue Tasks', value: 1, icon: AlertTriangle, color: 'text-amber-500', bg: 'bg-amber-50' },
        { label: 'Pending T&M', value: 2, icon: FileText, color: 'text-orange-500', bg: 'bg-orange-50' },
        { label: 'AI Risk Level', value: 'Low', icon: Sparkles, color: 'text-green-500', bg: 'bg-green-50' },
    ];

    const openTasks = tasks.filter(t => t.status !== 'Done').slice(0, 4);

    return (
        <div className="max-w-7xl mx-auto space-y-8">
            {/* Metrics Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                {metrics.map((m, i) => (
                    <DashboardMetric key={i} {...m} />
                ))}
            </div>

            {/* Quick Actions */}
            <div>
                <h3 className="text-sm font-bold text-zinc-900 mb-4">Quick Actions</h3>
                <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
                    <QuickActionButton icon={Plus} label="New Task" />
                    <QuickActionButton icon={FileText} label="New RFI" />
                    <QuickActionButton icon={CheckCircle2} label="New Punch Item" />
                    <QuickActionButton icon={Clipboard} label="Daily Log" />
                    <QuickActionButton icon={Hammer} label="Daywork Sheet" />
                    <QuickActionButton icon={Camera} label="Add Photo" />
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                {/* Left Column: Tasks & Activity */}
                <div className="lg:col-span-2 space-y-6">
                    <div className="bg-white border border-zinc-200 rounded-2xl shadow-sm overflow-hidden">
                        <div className="p-6 border-b border-zinc-100 flex justify-between items-center">
                            <h3 className="font-bold text-zinc-900 flex items-center gap-2"><List size={20} className="text-zinc-400" /> Open Tasks</h3>
                            <button className="text-xs font-medium text-[#0f5c82] flex items-center gap-1 hover:underline">View All ({tasks.length}) <ChevronRight size={12} /></button>
                        </div>
                        <div className="divide-y divide-zinc-50">
                            {openTasks.map(task => (
                                <div key={task.id} className="p-4 hover:bg-zinc-50 transition-colors flex items-center gap-4 group cursor-pointer">
                                    <div className={`p-2 rounded-lg bg-zinc-50 text-zinc-400 group-hover:text-[#0f5c82] group-hover:bg-blue-50 transition-colors`}>
                                        {task.priority === 'High' ? <AlertTriangle size={18} className="text-red-500" /> : <CheckSquare size={18} />}
                                    </div>
                                    <div className="flex-1">
                                        <div className="flex justify-between mb-1">
                                            <span className="text-sm font-semibold text-zinc-900 group-hover:text-[#0f5c82] transition-colors">{task.title}</span>
                                            <span className={`text-xs font-bold ${task.priority === 'High' ? 'text-red-600' : 'text-zinc-500'}`}>{task.dueDate}</span>
                                        </div>
                                        <div className="flex items-center gap-2 text-xs text-zinc-500">
                                            <span className="flex items-center gap-1"><User size={12} /> {task.assigneeName}</span>
                                            {task.priority && <span className={`px-1.5 rounded text-[10px] font-bold uppercase ${task.priority === 'High' ? 'bg-red-100 text-red-600' : 'bg-zinc-100 text-zinc-500'}`}>{task.priority}</span>}
                                        </div>
                                    </div>
                                    <button className="text-zinc-300 group-hover:text-[#0f5c82] transition-colors"><MoreHorizontal size={16} /></button>
                                </div>
                            ))}
                            {openTasks.length === 0 && <div className="p-8 text-center text-zinc-400 text-sm">No open tasks.</div>}
                        </div>
                    </div>

                    <div className="bg-white border border-zinc-200 rounded-2xl shadow-sm p-6">
                        <h3 className="font-bold text-zinc-900 mb-4">Project Description</h3>
                        <p className="text-sm text-zinc-600 leading-relaxed">{project.description}</p>
                    </div>
                </div>

                {/* Right Column: Deadlines & Contacts */}
                <div className="space-y-6">
                    <div className="bg-white border border-zinc-200 rounded-2xl shadow-sm p-6">
                        <h3 className="font-bold text-zinc-900 mb-4 flex items-center gap-2"><Calendar size={20} className="text-zinc-400" /> Upcoming Deadlines</h3>
                        {tasks.length === 0 ? (
                            <p className="text-sm text-zinc-400 italic">No upcoming deadlines.</p>
                        ) : (
                            <div className="space-y-6 relative pl-2">
                                {tasks.slice(0, 3).map((t, i) => (
                                    <div key={i} className="flex gap-4 relative group cursor-pointer">
                                        <div className="flex flex-col items-center">
                                            <div className={`w-3 h-3 rounded-full border-2 border-white shadow-sm ${t.priority === 'High' ? 'bg-red-500' : 'bg-blue-500'}`}></div>
                                            <div className="w-px h-full bg-zinc-100 -mb-6 mt-1 group-last:hidden"></div>
                                        </div>
                                        <div>
                                            <div className="text-xs font-bold text-zinc-500 mb-0.5">{t.dueDate}</div>
                                            <div className="text-sm font-bold text-zinc-900 group-hover:text-[#0f5c82] transition-colors">{t.title}</div>
                                            <div className="text-xs text-zinc-400 mt-0.5 flex items-center gap-1"><User size={10} /> {t.assigneeName}</div>
                                        </div>
                                    </div>
                                ))}
                            </div>
                        )}
                    </div>

                    <div className="bg-white border border-zinc-200 rounded-2xl shadow-sm p-6">
                        <h3 className="font-bold text-zinc-900 mb-4 flex items-center gap-2"><Users size={20} className="text-zinc-400" /> Key Contacts</h3>
                        <div className="space-y-4">
                            <div className="flex items-center justify-between">
                                <div>
                                    <div className="text-xs text-zinc-500 uppercase font-bold mb-0.5">Project Manager</div>
                                    <div className="text-sm font-medium text-zinc-900">{project.manager}</div>
                                </div>
                                <div className="w-8 h-8 bg-zinc-100 rounded-full flex items-center justify-center text-zinc-500 text-xs font-bold">
                                    {project.manager.split(' ').map(n=>n[0]).join('')}
                                </div>
                            </div>
                            <div className="flex items-center justify-between">
                                <div>
                                    <div className="text-xs text-zinc-500 uppercase font-bold mb-0.5">Superintendent</div>
                                    <div className="text-sm font-medium text-zinc-900">Jane Doe</div>
                                </div>
                                <div className="w-8 h-8 bg-zinc-100 rounded-full flex items-center justify-center text-zinc-500 text-xs font-bold">
                                    JD
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

const ProjectPhotos = ({ docs }: { docs: ProjectDocument[] }) => {
    // Mocking photo data for display purposes
    const photos = [
        { id: 'ph1', url: 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&w=300&q=80', date: '11 October 2025' },
        { id: 'ph2', url: 'https://images.unsplash.com/photo-1590069261209-f8e9b8642343?auto=format&fit=crop&w=300&q=80', date: '11 October 2025' },
        { id: 'ph3', url: 'https://images.unsplash.com/photo-1503387762-592deb58ef4e?auto=format&fit=crop&w=300&q=80', date: '11 October 2025' },
        { id: 'ph4', url: 'https://images.unsplash.com/photo-1580587771525-78b9dba3b91d?auto=format&fit=crop&w=300&q=80', date: '9 October 2025' },
        { id: 'ph5', url: 'https://images.unsplash.com/photo-1531834685032-c34bf0d84c77?auto=format&fit=crop&w=300&q=80', date: '9 October 2025' },
        { id: 'ph6', url: 'https://images.unsplash.com/photo-1599708153386-51e2b8895249?auto=format&fit=crop&w=300&q=80', date: '9 October 2025' },
        { id: 'ph7', url: 'https://images.unsplash.com/photo-1558402347-9539d93d7f0e?auto=format&fit=crop&w=300&q=80', date: '8 October 2025' },
        { id: 'ph8', url: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=300&q=80', date: '8 October 2025' },
        { id: 'ph9', url: 'https://images.unsplash.com/photo-1545558014-8692077e9b5c?auto=format&fit=crop&w=300&q=80', date: '8 October 2025' },
        { id: 'ph10', url: 'https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122?auto=format&fit=crop&w=300&q=80', date: '8 October 2025' },
    ];

    // Group photos by date
    const grouped = photos.reduce((acc, photo) => {
        if (!acc[photo.date]) acc[photo.date] = [];
        acc[photo.date].push(photo);
        return acc;
    }, {} as Record<string, typeof photos>);

    return (
        <div className="max-w-7xl mx-auto">
            <div className="flex justify-between items-center mb-8">
                <div>
                    <h2 className="text-2xl font-bold text-zinc-900">Photos</h2>
                    <p className="text-zinc-500 text-sm">Site progress and documentation</p>
                </div>
                <button className="bg-[#0f5c82] text-white w-12 h-12 rounded-xl flex items-center justify-center hover:bg-[#0c4a6e] shadow-lg transition-transform hover:scale-105">
                    <Plus size={24} />
                </button>
            </div>

            <div className="space-y-10">
                {Object.entries(grouped).map(([date, items]) => (
                    <div key={date} className="animate-in fade-in slide-in-from-bottom-4 duration-500">
                        <h3 className="text-lg font-bold text-zinc-900 mb-4 sticky top-0 bg-[#f4f4f5] py-2 z-10">{date}</h3>
                        <div className="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-4">
                            {items.map(item => (
                                <div key={item.id} className="aspect-square rounded-2xl overflow-hidden bg-zinc-200 relative group cursor-pointer shadow-sm hover:shadow-md transition-all">
                                    <img src={item.url} alt="Project" className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110" />
                                    <div className="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors" />
                                    <div className="absolute bottom-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity">
                                        <button className="p-2 bg-white/90 backdrop-blur rounded-full shadow-sm hover:bg-white text-zinc-800"><Maximize2 size={14} /></button>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
};

const ProjectTasks = ({ tasks }: { tasks: Task[] }) => (
    <div className="max-w-7xl mx-auto">
        <div className="flex justify-between mb-6">
            <h2 className="text-lg font-bold text-zinc-900">Project Schedule ({tasks.length})</h2>
            <div className="flex gap-2">
                <button className="px-3 py-1.5 border border-zinc-200 rounded-lg text-sm bg-white flex items-center gap-2 hover:bg-zinc-50 font-medium text-zinc-700">
                    <Filter size={14} /> Filter
                </button>
                <button className="px-3 py-1.5 bg-[#0f5c82] text-white rounded-lg text-sm font-medium hover:bg-[#0c4a6e] flex items-center gap-2 shadow-sm">
                    <Plus size={14} /> Add Task
                </button>
            </div>
        </div>
        <div className="bg-white border border-zinc-200 rounded-xl overflow-hidden shadow-sm">
            {tasks.length > 0 ? (
                <table className="w-full text-left text-sm">
                    <thead className="bg-zinc-50 border-b border-zinc-200 text-zinc-500 uppercase text-xs">
                        <tr>
                            <th className="px-6 py-4 font-bold tracking-wide">Task Name</th>
                            <th className="px-6 py-4 font-bold tracking-wide">Status</th>
                            <th className="px-6 py-4 font-bold tracking-wide">Assignee</th>
                            <th className="px-6 py-4 font-bold tracking-wide">Due Date</th>
                            <th className="px-6 py-4 font-bold tracking-wide">Priority</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-zinc-50">
                        {tasks.map((task, i) => (
                            <tr key={i} className="hover:bg-zinc-50/80 transition-colors">
                                <td className="px-6 py-4 font-medium text-zinc-900">{task.title}</td>
                                <td className="px-6 py-4">
                                    <span className={`px-2.5 py-1 rounded-full text-xs font-bold ${
                                        task.status === 'Done' ? 'bg-green-100 text-green-700' :
                                        task.status === 'In Progress' ? 'bg-blue-100 text-blue-700' :
                                        'bg-zinc-100 text-zinc-600'
                                    }`}>{task.status}</span>
                                </td>
                                <td className="px-6 py-4 text-zinc-600 flex items-center gap-2">
                                    <div className="w-6 h-6 rounded-full bg-zinc-200 flex items-center justify-center text-[10px] font-bold text-zinc-500">
                                        {task.assigneeName ? task.assigneeName.charAt(0) : 'U'}
                                    </div>
                                    {task.assigneeName}
                                </td>
                                <td className="px-6 py-4 text-zinc-600 font-mono text-xs">{task.dueDate}</td>
                                <td className="px-6 py-4">
                                    <span className={`px-2 py-1 rounded text-xs font-bold border ${
                                        task.priority === 'High' ? 'text-red-600 bg-red-50 border-red-100' :
                                        task.priority === 'Medium' ? 'text-orange-600 bg-orange-50 border-orange-100' :
                                        'text-green-600 bg-green-50 border-green-100'
                                    }`}>{task.priority}</span>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
            ) : (
                <div className="p-12 text-center text-zinc-500 flex flex-col items-center">
                    <CheckSquare size={48} className="mb-4 opacity-20" />
                    <p>No tasks assigned to this project yet.</p>
                    <button className="mt-4 text-[#0f5c82] font-medium hover:underline">Create your first task</button>
                </div>
            )}
        </div>
    </div>
);

const ProjectTeam = ({ team }: { team: TeamMember[] }) => (
    <div className="max-w-7xl mx-auto">
         {team.length > 0 ? (
             <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                 {team.map((m) => (
                     <div key={m.id} className="bg-white border border-zinc-200 p-6 rounded-xl shadow-sm flex items-center gap-4 hover:border-blue-200 transition-colors cursor-pointer group">
                         <div className={`w-14 h-14 rounded-full ${m.color} flex items-center justify-center text-white font-bold text-lg shadow-sm ring-2 ring-white`}>
                            {m.initials}
                         </div>
                         <div>
                             <div className="font-bold text-zinc-900 group-hover:text-[#0f5c82] transition-colors">{m.name}</div>
                             <div className="text-xs text-zinc-500 font-medium mb-1">{m.role}</div>
                             <div className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded-full inline-block ${m.status === 'On Site' ? 'bg-green-100 text-green-700' : 'bg-zinc-100 text-zinc-500'}`}>
                                 {m.status}
                             </div>
                         </div>
                     </div>
                 ))}
                 <button className="border-2 border-dashed border-zinc-300 rounded-xl p-6 flex flex-col items-center justify-center text-zinc-400 hover:border-[#0f5c82] hover:text-[#0f5c82] transition-colors min-h-[100px] hover:bg-blue-50/30">
                     <Plus size={32} className="mb-2" />
                     <span className="font-medium text-sm">Add Member</span>
                 </button>
             </div>
         ) : (
             <div className="bg-white border border-zinc-200 rounded-xl p-12 text-center text-zinc-500">
                 <Users size={48} className="mx-auto mb-4 opacity-20" />
                 <p className="mb-4">No team members assigned to this project.</p>
                 <button className="px-4 py-2 bg-[#0f5c82] text-white rounded-lg font-medium hover:bg-[#0c4a6e]">Assign Staff</button>
             </div>
         )}
    </div>
);

const ProjectBudget = ({ project }: { project: Project }) => (
    <div className="max-w-7xl mx-auto bg-white border border-zinc-200 rounded-xl p-8 shadow-sm">
        <div className="flex justify-between items-center mb-8">
            <h2 className="text-lg font-bold text-zinc-900">Financial Overview</h2>
            <button className="text-sm text-[#0f5c82] font-medium hover:underline">View Detailed Report</button>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
            <div className="p-4 bg-zinc-50 rounded-xl border border-zinc-100">
                <div className="text-zinc-500 text-xs uppercase font-bold mb-2">Total Budget</div>
                <div className="text-3xl font-bold text-zinc-900 tracking-tight">£{project.budget.toLocaleString()}</div>
            </div>
            <div className="p-4 bg-zinc-50 rounded-xl border border-zinc-100">
                <div className="text-zinc-500 text-xs uppercase font-bold mb-2">Amount Spent</div>
                <div className="text-3xl font-bold text-orange-600 tracking-tight">£{project.spent.toLocaleString()}</div>
            </div>
            <div className="p-4 bg-zinc-50 rounded-xl border border-zinc-100">
                <div className="text-zinc-500 text-xs uppercase font-bold mb-2">Remaining</div>
                <div className="text-3xl font-bold text-green-600 tracking-tight">£{(project.budget - project.spent).toLocaleString()}</div>
            </div>
        </div>
        
        <div className="mb-2 flex justify-between text-xs font-medium text-zinc-600">
            <span>Budget Utilized</span>
            <span>{Math.round((project.spent / project.budget) * 100) || 0}%</span>
        </div>
        <div className="w-full bg-zinc-100 h-3 rounded-full overflow-hidden mb-2">
             <div className="bg-gradient-to-r from-[#0f5c82] to-[#1e3a8a] h-full transition-all duration-1000 rounded-full" style={{width: `${(project.spent / project.budget) * 100}%`}}></div>
        </div>
    </div>
);

const ProjectDocuments = ({ docs }: { docs: ProjectDocument[] }) => (
    <div className="max-w-7xl mx-auto">
        <div className="flex justify-between items-center mb-6">
            <h2 className="text-lg font-bold text-zinc-900">Construction Drawings & Documents</h2>
            <button className="flex items-center gap-2 px-4 py-2 bg-[#0f5c82] text-white rounded-lg text-sm font-medium hover:bg-[#0c4a6e] shadow-sm">
                <Plus size={16} /> Upload
            </button>
        </div>

        {docs.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                {docs.map((doc, i) => (
                    <div key={i} className="bg-white border border-zinc-200 rounded-2xl p-5 hover:shadow-md transition-all cursor-pointer group relative flex flex-col">
                        <div className="h-32 bg-zinc-100 rounded-xl mb-4 flex items-center justify-center text-zinc-300 group-hover:text-[#0f5c82] group-hover:bg-blue-50 transition-colors">
                            {doc.type === 'Image' ? <ImageIcon size={40} /> : 
                             doc.type === 'CAD' ? <Box size={40} /> :
                             <FileText size={40} />}
                        </div>
                        <h4 className="font-bold text-zinc-900 text-sm mb-1 truncate">{doc.name}</h4>
                        <div className="flex items-center gap-2 text-xs text-zinc-500 mb-4">
                            <span className="uppercase font-bold bg-zinc-100 px-1.5 rounded">{doc.type}</span>
                            <span>{doc.size}</span>
                        </div>
                        <div className="mt-auto pt-3 border-t border-zinc-50 flex justify-between items-center text-xs text-zinc-400">
                            <span>Updated {doc.date}</span>
                            <Download size={16} className="hover:text-[#0f5c82] transition-colors" />
                        </div>
                    </div>
                ))}
            </div>
        ) : (
            <div className="p-12 bg-white border border-zinc-200 rounded-xl text-center text-zinc-500 italic">No documents uploaded for this project.</div>
        )}
    </div>
);

const ProjectBIM = () => {
  const [isLoaded, setIsLoaded] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [layers, setLayers] = useState({ structural: true, mep: true, architectural: true });
  const [rotation, setRotation] = useState(45);
  const [selectedPart, setSelectedPart] = useState<string | null>(null);

  const handleLoad = () => {
      setIsLoading(true);
      setTimeout(() => {
          setIsLoading(false);
          setIsLoaded(true);
      }, 2000);
  };

  return (
    <div className="flex flex-col h-[700px] bg-zinc-900 rounded-xl overflow-hidden shadow-xl border border-zinc-800">
         {!isLoaded ? (
             <div className="flex-1 flex flex-col items-center justify-center relative">
                 <div className="absolute inset-0 opacity-20" style={{backgroundImage: 'radial-gradient(#4ade80 1px, transparent 1px)', backgroundSize: '20px 20px'}}></div>
                 {isLoading ? (
                     <div className="text-center z-10">
                         <div className="w-12 h-12 border-4 border-[#0f5c82] border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
                         <h3 className="text-zinc-300 font-medium animate-pulse">Initializing WebGL Context...</h3>
                     </div>
                 ) : (
                     <div className="text-center z-10">
                         <Layers size={64} className="text-zinc-700 mx-auto mb-4" />
                         <h3 className="text-zinc-300 font-bold text-lg">BIM Model Viewer</h3>
                         <p className="text-zinc-500 text-sm mb-6">Interactive 3D model requires WebGL context</p>
                         <button onClick={handleLoad} className="px-6 py-2 bg-[#0f5c82] text-white rounded-lg hover:bg-[#0c4a6e] transition-all font-medium">
                             Load Model
                         </button>
                     </div>
                 )}
             </div>
         ) : (
             <div className="flex-1 flex">
                 {/* Sidebar Tools */}
                 <div className="w-64 bg-zinc-950 border-r border-zinc-800 flex flex-col p-4">
                     <div className="text-xs font-bold text-zinc-500 uppercase mb-4">Model Layers</div>
                     <div className="space-y-2 mb-8">
                         {Object.entries(layers).map(([key, val]) => (
                             <button 
                                key={key} 
                                onClick={() => setLayers(prev => ({...prev, [key]: !val}))}
                                className="w-full flex items-center justify-between p-2 rounded hover:bg-zinc-900 transition-colors"
                             >
                                 <span className="text-sm text-zinc-300 capitalize">{key}</span>
                                 {val ? <Eye size={16} className="text-green-500" /> : <EyeOff size={16} className="text-zinc-600" />}
                             </button>
                         ))}
                     </div>
                     
                     <div className="text-xs font-bold text-zinc-500 uppercase mb-4">Properties</div>
                     {selectedPart ? (
                         <div className="bg-zinc-900 p-3 rounded border border-zinc-800 text-sm space-y-2">
                             <div className="text-zinc-400">Type: <span className="text-zinc-200">Steel Beam I-200</span></div>
                             <div className="text-zinc-400">Material: <span className="text-zinc-200">Galvanized Steel</span></div>
                             <div className="text-zinc-400">Volume: <span className="text-zinc-200">0.4 m³</span></div>
                             <div className="text-zinc-400">Status: <span className="text-green-500">Installed</span></div>
                         </div>
                     ) : (
                         <div className="text-zinc-600 text-xs italic">Select an element to view properties</div>
                     )}

                     <div className="mt-auto">
                         <button onClick={() => setIsLoaded(false)} className="w-full py-2 border border-zinc-800 text-zinc-500 rounded hover:text-zinc-300 text-sm">Close Model</button>
                     </div>
                 </div>

                 {/* 3D Viewport */}
                 <div className="flex-1 relative bg-[#0f172a] overflow-hidden">
                     {/* Toolbar */}
                     <div className="absolute top-4 left-1/2 -translate-x-1/2 bg-zinc-900/90 backdrop-blur border border-zinc-700 rounded-lg p-1 flex gap-1 z-20">
                         <button className="p-2 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded" title="Rotate"><RotateCw size={18} /></button>
                         <button className="p-2 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded" title="Pan"><MousePointer2 size={18} /></button>
                         <button className="p-2 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded" title="Zoom"><ZoomIn size={18} /></button>
                         <div className="w-px bg-zinc-700 mx-1" />
                         <button className="p-2 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded" title="Measure"><Ruler size={18} /></button>
                         <button className="p-2 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded" title="Fullscreen"><Maximize2 size={18} /></button>
                         <button className="p-2 text-zinc-400 hover:text-white hover:bg-zinc-800 rounded" title="Settings"><Settings size={18} /></button>
                     </div>

                     {/* Simulated 3D Model Visualization */}
                     <div className="absolute inset-0 flex items-center justify-center">
                         <div 
                            className="relative w-[600px] h-[400px] transition-transform duration-500" 
                            style={{ transform: `perspective(1000px) rotateX(60deg) rotateZ(${rotation}deg) scale(0.8)` }}
                         >
                             {/* Base Grid */}
                             <div className="absolute inset-0 border-4 border-blue-500/20 bg-blue-500/5" 
                                  style={{backgroundImage: 'linear-gradient(rgba(59, 130, 246, 0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(59, 130, 246, 0.1) 1px, transparent 1px)', backgroundSize: '50px 50px'}}>
                             </div>
                             
                             {/* Structural Layer */}
                             {layers.structural && (
                                 <div className="absolute top-10 left-10 right-10 bottom-10 border-4 border-orange-500/40 transform translate-z-10 pointer-events-none">
                                      <div className="absolute top-0 left-0 w-4 h-full bg-orange-500/40"></div>
                                      <div className="absolute top-0 right-0 w-4 h-full bg-orange-500/40"></div>
                                      <div className="absolute top-0 left-0 w-full h-4 bg-orange-500/40"></div>
                                      <div className="absolute bottom-0 left-0 w-full h-4 bg-orange-500/40"></div>
                                      
                                      {/* Interactive Beam */}
                                      <div 
                                        onClick={() => setSelectedPart('beam')}
                                        className="absolute top-1/2 left-0 w-full h-8 bg-orange-600/60 cursor-pointer hover:bg-orange-500 transition-colors pointer-events-auto"
                                      ></div>
                                 </div>
                             )}

                             {/* Architectural Layer */}
                             {layers.architectural && (
                                 <div className="absolute inset-20 border-2 border-zinc-400/30 bg-zinc-500/10 transform translate-z-20 pointer-events-none"></div>
                             )}

                             {/* MEP Layer */}
                             {layers.mep && (
                                 <svg className="absolute inset-0 w-full h-full pointer-events-none" style={{transform: 'translateZ(30px)'}}>
                                      <path d="M50,50 Q300,400 550,50" stroke="#10b981" strokeWidth="4" fill="none" strokeDasharray="10 5" className="opacity-60" />
                                 </svg>
                             )}
                         </div>
                     </div>
                     
                     {/* Rotation Control Hint */}
                     <div className="absolute bottom-4 right-4 flex gap-2">
                         <button onClick={() => setRotation(r => r - 45)} className="p-2 bg-zinc-800 text-white rounded-full hover:bg-zinc-700 border border-zinc-700">⟲</button>
                         <button onClick={() => setRotation(r => r + 45)} className="p-2 bg-zinc-800 text-white rounded-full hover:bg-zinc-700 border border-zinc-700">⟳</button>
                     </div>
                 </div>
             </div>
         )}
    </div>
  );
};

const ProjectRFI = () => {
  const [rfis, setRfis] = useState([
      { id: 'RFI-001', subject: 'Clarification on HVAC Ducting', date: '2025-11-01', status: 'Closed', assignedTo: 'Mike Thompson', priority: 'High' },
      { id: 'RFI-002', subject: 'Concrete Mix Specification', date: '2025-11-05', status: 'Open', assignedTo: 'David Chen', priority: 'Critical' },
      { id: 'RFI-003', subject: 'Window Installation Height', date: '2025-11-08', status: 'Draft', assignedTo: '-', priority: 'Medium' },
  ]);
  const [view, setView] = useState<'LIST' | 'CREATE' | 'DETAIL'>('LIST');
  const [selectedRFI, setSelectedRFI] = useState<any>(null);

  return (
    <div className="max-w-7xl mx-auto">
         {view === 'LIST' && (
             <>
                <div className="flex justify-between items-center mb-6">
                    <h2 className="text-lg font-bold text-zinc-900">Request for Information (RFI)</h2>
                    <button 
                        onClick={() => setView('CREATE')}
                        className="px-4 py-2 bg-[#0f5c82] text-white rounded-lg font-medium hover:bg-[#0c4a6e] flex items-center gap-2 shadow-sm"
                    >
                        <Plus size={16} /> Create RFI
                    </button>
                </div>
                
                <div className="bg-white border border-zinc-200 rounded-xl overflow-hidden shadow-sm">
                    <table className="w-full text-left text-sm">
                        <thead className="bg-zinc-50 border-b border-zinc-200 text-zinc-500 uppercase text-xs">
                            <tr>
                                <th className="px-6 py-4 font-medium">ID</th>
                                <th className="px-6 py-4 font-medium">Subject</th>
                                <th className="px-6 py-4 font-medium">Status</th>
                                <th className="px-6 py-4 font-medium">Assigned To</th>
                                <th className="px-6 py-4 font-medium">Date</th>
                                <th className="px-6 py-4 font-medium text-right">Action</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-zinc-100">
                            {rfis.map(rfi => (
                                <tr key={rfi.id} className="hover:bg-zinc-50 transition-colors cursor-pointer" onClick={() => { setSelectedRFI(rfi); setView('DETAIL'); }}>
                                    <td className="px-6 py-4 font-mono text-xs text-zinc-500">{rfi.id}</td>
                                    <td className="px-6 py-4 font-medium text-zinc-800">{rfi.subject}</td>
                                    <td className="px-6 py-4">
                                        <span className={`px-2 py-1 rounded-full text-xs font-bold ${
                                            rfi.status === 'Open' ? 'bg-green-100 text-green-700' :
                                            rfi.status === 'Closed' ? 'bg-zinc-100 text-zinc-500' :
                                            'bg-orange-100 text-orange-700'
                                        }`}>
                                            {rfi.status}
                                        </span>
                                    </td>
                                    <td className="px-6 py-4 text-zinc-600">{rfi.assignedTo}</td>
                                    <td className="px-6 py-4 text-zinc-500 text-xs">{rfi.date}</td>
                                    <td className="px-6 py-4 text-right text-zinc-400">
                                        <ArrowRight size={16} />
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
             </>
         )}

         {view === 'CREATE' && (
             <div className="bg-white border border-zinc-200 rounded-xl p-8 shadow-sm max-w-3xl mx-auto animate-in slide-in-from-right-4">
                 <div className="flex justify-between items-center mb-6">
                     <h2 className="text-xl font-bold text-zinc-900">New RFI Draft</h2>
                     <button onClick={() => setView('LIST')} className="text-zinc-500 hover:text-zinc-800"><XCircle size={24} /></button>
                 </div>
                 
                 <div className="space-y-6">
                     <div>
                         <label className="block text-sm font-medium text-zinc-700 mb-2">Subject</label>
                         <input type="text" className="w-full p-3 border border-zinc-200 rounded-lg focus:ring-2 focus:ring-[#0f5c82] outline-none" placeholder="e.g., Structural Beam Conflict" />
                     </div>
                     
                     <div className="grid grid-cols-2 gap-6">
                         <div>
                             <label className="block text-sm font-medium text-zinc-700 mb-2">Assign To</label>
                             <select className="w-full p-3 border border-zinc-200 rounded-lg bg-white">
                                 <option>Architect</option>
                                 <option>Structural Engineer</option>
                                 <option>Project Manager</option>
                             </select>
                         </div>
                         <div>
                             <label className="block text-sm font-medium text-zinc-700 mb-2">Priority</label>
                             <select className="w-full p-3 border border-zinc-200 rounded-lg bg-white">
                                 <option>Normal</option>
                                 <option>High</option>
                                 <option>Critical</option>
                             </select>
                         </div>
                     </div>

                     <div>
                         <label className="block text-sm font-medium text-zinc-700 mb-2">Question / Description</label>
                         <textarea className="w-full p-3 border border-zinc-200 rounded-lg h-32 resize-none focus:ring-2 focus:ring-[#0f5c82] outline-none" placeholder="Describe the issue..." />
                     </div>

                     <div>
                         <label className="block text-sm font-medium text-zinc-700 mb-2">Attachments</label>
                         <div className="border-2 border-dashed border-zinc-200 rounded-lg p-6 text-center text-zinc-400 hover:bg-zinc-50 transition-colors cursor-pointer">
                             <Paperclip size={24} className="mx-auto mb-2" />
                             <span>Click to upload photos or drawings</span>
                         </div>
                     </div>
                     
                     <div className="flex justify-end gap-4 pt-4 border-t border-zinc-100">
                         <button onClick={() => setView('LIST')} className="px-6 py-3 border border-zinc-200 text-zinc-600 rounded-lg font-medium hover:bg-zinc-50">Cancel</button>
                         <button onClick={() => { setView('LIST'); /* Add logic */ }} className="px-6 py-3 bg-[#0f5c82] text-white rounded-lg font-medium hover:bg-[#0c4a6e]">Submit RFI</button>
                     </div>
                 </div>
             </div>
         )}

         {view === 'DETAIL' && selectedRFI && (
             <div className="bg-white border border-zinc-200 rounded-xl shadow-sm overflow-hidden animate-in slide-in-from-right-4 h-[600px] flex flex-col">
                 {/* RFI Header */}
                 <div className="p-6 border-b border-zinc-200 bg-zinc-50 flex justify-between items-start">
                     <div>
                         <div className="flex items-center gap-3 mb-2">
                             <button onClick={() => setView('LIST')} className="text-zinc-400 hover:text-zinc-700"><ArrowLeft size={20} /></button>
                             <span className="text-xs font-mono text-zinc-500 bg-zinc-200 px-2 py-0.5 rounded">{selectedRFI.id}</span>
                             <span className={`text-xs font-bold px-2 py-0.5 rounded uppercase ${selectedRFI.priority === 'Critical' ? 'text-red-600 bg-red-100' : 'text-zinc-600 bg-zinc-200'}`}>{selectedRFI.priority}</span>
                         </div>
                         <h2 className="text-xl font-bold text-zinc-900">{selectedRFI.subject}</h2>
                     </div>
                     <div className="flex items-center gap-4 text-sm">
                         <div className="text-right">
                             <div className="text-zinc-500 text-xs">Assigned To</div>
                             <div className="font-bold text-zinc-800">{selectedRFI.assignedTo}</div>
                         </div>
                         <div className="w-px h-8 bg-zinc-200"></div>
                         <button className="px-4 py-2 bg-white border border-zinc-200 rounded-lg text-zinc-700 hover:bg-zinc-50 text-sm font-medium shadow-sm">
                             Generate Report
                         </button>
                     </div>
                 </div>

                 {/* Conversation Thread */}
                 <div className="flex-1 overflow-y-auto p-6 bg-zinc-50/50 space-y-6">
                     <div className="flex gap-4">
                         <div className="w-10 h-10 bg-[#0f5c82] rounded-full flex items-center justify-center text-white font-bold text-sm shrink-0">JA</div>
                         <div className="flex-1">
                             <div className="flex justify-between items-baseline mb-1">
                                 <span className="font-bold text-zinc-900">John Anderson</span>
                                 <span className="text-xs text-zinc-400">Nov 5, 10:30 AM</span>
                             </div>
                             <div className="bg-white border border-zinc-200 p-4 rounded-lg rounded-tl-none shadow-sm text-zinc-700 text-sm leading-relaxed">
                                 Please confirm if the specified concrete mix C35/45 is suitable for the foundation slab given the recent soil test results indicating higher sulphate content.
                             </div>
                         </div>
                     </div>

                     <div className="flex gap-4">
                         <div className="w-10 h-10 bg-green-600 rounded-full flex items-center justify-center text-white font-bold text-sm shrink-0">SE</div>
                         <div className="flex-1">
                             <div className="flex justify-between items-baseline mb-1">
                                 <span className="font-bold text-zinc-900">Structural Engineer</span>
                                 <span className="text-xs text-zinc-400">Nov 6, 09:15 AM</span>
                             </div>
                             <div className="bg-white border border-zinc-200 p-4 rounded-lg rounded-tl-none shadow-sm text-zinc-700 text-sm leading-relaxed">
                                 <p className="mb-2">Reviewed the soil report. Standard C35 is insufficient.</p>
                                 <p>Recommendation: Switch to Sulphate Resisting Portland Cement (SRPC) with a minimum strength class of C40/50. Updated spec attached.</p>
                                 <div className="mt-3 flex items-center gap-2 p-2 bg-zinc-50 rounded border border-zinc-200 w-fit">
                                     <FileText size={16} className="text-red-500" />
                                     <span className="text-xs font-medium text-blue-600 underline cursor-pointer">Spec_Update_v2.pdf</span>
                                 </div>
                             </div>
                         </div>
                     </div>
                 </div>

                 {/* Reply Box */}
                 <div className="p-4 border-t border-zinc-200 bg-white">
                     <div className="relative">
                         <textarea className="w-full p-4 pr-12 border border-zinc-200 rounded-xl focus:ring-2 focus:ring-[#0f5c82] outline-none resize-none h-24 text-sm" placeholder="Type your response..." />
                         <div className="absolute bottom-3 right-3 flex gap-2">
                             <button className="p-2 text-zinc-400 hover:bg-zinc-100 rounded-full"><Paperclip size={18} /></button>
                             <button className="p-2 bg-[#0f5c82] text-white rounded-lg hover:bg-[#0c4a6e]"><Send size={18} /></button>
                         </div>
                     </div>
                 </div>
             </div>
         )}
    </div>
  );
};

export default ProjectDetailsView;
